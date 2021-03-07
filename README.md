## Service List

### Cromwell
#### 安装配置 Cromwell

##### 拷贝配置文件

```
cp cromwell-local.conf /etc/cromwell-local.conf
```

##### 安装 Cromwell 软件

```
```

#### 使用方法

##### 启动 MySQL

```
docker-compose up -d

# 遇到 Permission Denied 时，修改 data/mysql 与 data/mysql-log 权限
chown polkitd data/mysql data/mysql-log
```

##### 启动 Cromwell 服务
前提：系统上已经安装 Cromwell 服务，具体安装方法详见`安装 Cromwell`

```
systemctl start cromwell-35
```

### Metabase
1. Get the build version of metabase from aliyun docker registry.
e.g. registry.cn-shanghai.aliyuncs.com/pgx-docker-registry/metabase:tgmc-ed1edf0f

2. Modify METABASE_BUILD_VERSION variable in `metabase/config/metabase_database.env` for docker-compose
```
METABASE_BUILD_VERSION=tgmc-ed1edf0f
```

3. Sync the metabase directory to the server
```
rsync -avP ./metabase/ <remote-directory> --exclude data
```

4. Launch metabase service
```
cd <remote-direcotry>
docker-compose up -d
```

### Shiny-server

### Yapi

### Drone