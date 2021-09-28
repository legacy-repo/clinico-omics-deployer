local bearer = function()
    local opts = {
        introspection_endpoint = os.getenv("INTROSPEC_ENDPOINT"),
        introspection_token_param_name = 'token',
        client_id = os.getenv("CLIENT_ID"),
        client_secret = os.getenv("CLIENT_SECRET"),
        ssl_verify = "no"
    }

    local res, err = require("resty.openidc").introspect(opts)

    if err then
        ngx.status = 403
        ngx.say(err)
        ngx.exit(ngx.HTTP_FORBIDDEN)
    end

    if res.active then
        -- optionally set Authorization header Bearer token style regardless of how token received
        -- if you want to forward it by setting your nginx.conf something like:
        --     proxy_set_header Authorization $http_authorization;`
        if ngx.var.PENETRATION == "ON" then
            ngx.req.set_header("Authorization", ngx.var.http_Authorization)
        else
            ngx.req.set_header("Authorization", "")
        end

        ngx.req.set_header("X-Auth-User", res.username)
    else
        ngx.status = ngx.HTTP_UNAUTHORIZED
        ngx.log(ngx.WARN, "Token verification failed")
        ngx.header.content_type = "application/json; charset=utf-8"
        ngx.say("{\"error\": \"Token verification failed\"}")
        ngx.exit(ngx.HTTP_UNAUTHORIZED)
    end
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
