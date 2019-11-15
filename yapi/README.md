<h2 align="center">Docker & Docker-compose for YApi</h2>
<p align="center">一键部署YApi</p>

<p align="center">yjcyxky <yjcyxky@163.com> </p>

## 友情提醒
### ⚠️注意
⚠️注意：本仓库目前只支持安装，暂不支持升级，请知晓。如需升级请备份mongoDB内的数据。

### 使用
默认密码是：`ymfe.org`，安装成功后进入后台修改

## 构建Docker镜像
1. 拷贝 `./config/yapi.env.sample` 至 `./config/yapi.env`

2. 按照实际需求修改如下变量：
```
# 日子目录
LOG_PATH=/tmp/yapi.log
# 管理员邮箱
ADMIN_EMAIL=example@163.com
# 绑定邮件发送者邮箱
SENDER_EMAIL=example@163.com
# 发送者邮箱密码
EMAIL_PASSWORD=your_password
# LDAP服务(默认开启)
LDAP_SERVER=ldap\:\/\/l\-ldapt1\.com
# 
LDAP_BASEDN=CN\=Admin\,CN\=Users\,DC\=test\,DC\=com
# 
LDAP_PASSWORD=password123
# 
LDAP_SEARCHDN=OU\=UserContainer\,DC\=test\,DC\=com
# 
LDAP_SEARCH_STANDARD=""
# 指定YAPI版本，务必依据实际需要修改
VERSION=1.8.5
# 指定Docker构建镜像的Tag，依据Version修改。建议采用{VERSION}-{COMMIT_ID}的形式
YAPI_BUILD_VERSION=v1.8.5-cd990a6
YAPI_DOCKER_REPO=registry.cn-shanghai.aliyuncs.com/pgx-docker-registry/yapi
```

3. 运行`bash build.sh`构建Docker镜像

4. 推送Docker镜像至远程仓库
```
docker push ${YAPI_DOCKER_REPO}:${YAPI_BUILD_VERSION}
```

## 部署docker-compose
请务必先完成"构建Docker镜像"步骤
```
# 启动service
docker-compose up -d

# 关闭service
docker-compose stop

# 关闭 & 移除service
docker-compose down
```