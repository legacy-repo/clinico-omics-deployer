<h2 align="center">Docker for YApi</h2>
<p align="center">一键部署YApi</p>

<p align="center">yjcyxky <yjcyxky@163.com> </p>

## ⚠️注意
⚠️注意：本仓库目前只支持安装，暂不支持升级，请知晓。如需升级请备份mongoDB内的数据。

## 使用
默认密码是：`ymfe.org`，安装成功后进入后台修改

## 可修改变量
| 环境变量       | 默认值         | 建议         |
| ------------- |:-------------:|:-----------:|
| VERSION | v1.8.5-cd990a6  | 可以修改成yapi已发布的版本   |
| PORT | 3000  | 可修改 | 
| ADMIN_EMAIL | me@jinfeijie.cn  | 建议修改 | 
| DB_SERVER | mongo(127.0.0.1)  | 不建议修改 |
| DB_NAME | yapi  | 不建议修改 |
| DB_PORT | 27017 | 不建议修改|
| EMAIL | example@163.com | 务必修改 |
| EMAIL_PASSWORD | your_password | 务必修改 |



## 获取本镜像
🚘获取本镜像：`docker pull registry.cn-shanghai.aliyuncs.com/pgx-docker-registry/yapi:v1.8.5-cd990a6`

## docker-compose 部署
复制`config/yapi.env.sample`为`yapi.env`，并按照实际情况修改相关变量的值

## 启动方法

1. 修改`config/yapi.env`文件里面相关参数

2. 启动服务：`docker-compose up -d`