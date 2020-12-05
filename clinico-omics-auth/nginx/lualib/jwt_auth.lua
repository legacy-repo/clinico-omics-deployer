local bearer = function()
    local jwt = require "resty.jwt"

    -- first try to find JWT token as url parameter e.g. ?token=BLAH
    local token = ngx.var.arg_token

    -- next try to find JWT token as Cookie e.g. token=BLAH
    if token == nil then token = ngx.var.cookie_token end

    -- try to find JWT token in Authorization header Bearer string
    if token == nil then
        local auth_header = ngx.var.http_Authorization
        if auth_header then
            _, _, token = string.find(auth_header, "Bearer%s+(.+)")
        end
    end

    -- finally, if still no JWT token, kick out an error and exit
    if token == nil then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.header.content_type = "application/json; charset=utf-8"
        ngx.say("{\"error\": \"missing JWT token or Authorization header\"}")
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end

    -- validate any specific claims you need here
    -- https://github.com/SkyLothar/lua-resty-jwt#jwt-validators
    local validators = require "resty.jwt-validators"
    local claim_spec = {
        exp = validators.is_not_expired(),
        sub = validators.opt_matches("^[0-9a-zA-Z-]+$")
    }

    -- make sure to set and put "env SECRET_KEY;" in nginx.conf
    -- local jwt_obj = jwt:verify(os.getenv("SECRET_KEY"), token, claim_spec)
    -- if not jwt_obj["verified"] then
    --    ngx.status = ngx.HTTP_UNAUTHORIZED
    --    ngx.log(ngx.WARN, jwt_obj.reason)
    --    ngx.header.content_type = "application/json; charset=utf-8"
    --    ngx.say("{\"error\": \"" .. jwt_obj.reason .. "\"}")
    --    ngx.exit(ngx.HTTP_UNAUTHORIZED)
    -- end

    local zhttp = require "resty.http"
    
    local function http_get_client(url, token, timeout)
        local httpc = zhttp.new()
 
        timeout = timeout or 30000
        httpc:set_timeout(timeout)
 
        local res, err_ = httpc:request_uri(url, {
            method = "GET",
            headers = {
                ["Content-Type"] = "application/x-www-form-urlencoded",
                ["Authorization"] = "Bearer " .. token
            }
        })

        httpc:close()
        return res, err_
    end

    ngx.log(ngx.WARN, os.getenv("USER_INFO_URL"))
    local res, err = http_get_client(os.getenv("USER_INFO_URL"), token, 1000)
    ngx.log(ngx.WARN, token, " ", err, " ", res:read_body())

    if res.status == 401 then
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.log(ngx.WARN, "Token verification failed")
        ngx.header.content_type = "application/json; charset=utf-8"
        ngx.say("{\"error\": \"Token verification failed\"}")
        ngx.exit(ngx.HTTP_UNAUTHORIZED)        
    end

    -- optionally set Authorization header Bearer token style regardless of how token received
    -- if you want to forward it by setting your nginx.conf something like:
    --     proxy_set_header Authorization $http_authorization;`
    if ngx.var.PENETRATION == "ON" then
        ngx.req.set_header("Authorization", ngx.var.http_Authorization)
    else
        ngx.req.set_header("Authorization", "")
    end

    local json = require("framework.shared.json")
    local body = json.decode(res:read_body())
    ngx.req.set_header("X-Auth-User", body.preferred_username)
end

local basic_auth = function()
    local username = os.getenv("USERNAME")
    local password = os.getenv("PASSWORD")

    if ngx.var.remote_user == username and ngx.var.remote_passwd == password then
        if ngx.var.PENETRATION == "ON" then
            ngx.req.set_header("Authorization", ngx.var.http_Authorization)
        else
            ngx.req.set_header("Authorization", "")
        end
        ngx.req.set_header("X-Auth-User", ngx.var.remote_user)
        return
    end

    ngx.header.www_authenticate = [[Basic realm="Restricted"]]
    ngx.exit(401)
end

local auth_mode = os.getenv("AUTH_MODE")

if auth_mode == "BASIC_AUTH" or ngx.var.BASIC_AUTH == "true" then
    basic_auth()
else
    bearer()
end
