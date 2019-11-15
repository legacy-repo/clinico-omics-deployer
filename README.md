## Service List
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