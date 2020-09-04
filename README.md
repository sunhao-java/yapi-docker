<h2 align="center">Docker for YApi</h2>
<p align="center">一键部署YApi</p>

Fork From JimCY [[me@jinfeijie.cn]](https://github.com/jinfeijie/yapi)

## ⚠️注意
⚠️注意：本仓库目前只支持安装，暂不支持升级，请知晓。如需升级请备份mongoDB内的数据。

## 使用
默认密码是：`ymfe.org`，安装成功后进入后台修改

## 可修改变量
| 环境变量       | 默认值         | 建议         |
| ------------- |:-------------:|:-----------:|
| VERSION | 1.9.2  | 可以修改成yapi已发布的版本   |
| HOME | /home | 可修改 |  
| PORT | 3000  | 可修改 | 
| ADMIN_EMAIL | sunhao.java@gmail.com  | 建议修改 | 
| DB_SERVER | mongo(127.0.0.1)  | 不建议修改 |
| DB_NAME | yapi  | 不建议修改 |
| DB_PORT | 27017 | 不建议修改|
| VENDORS | ${HOME}/vendors | 不建议修改  | 

## docker-compose 部署
```
version: '2.1'
services:
  yapi:
    build: ./
    container_name: yapi
    environment:
      - VERSION=1.9.2
      - LOG_PATH=/tmp/yapi.log
      - HOME=/home
      - PORT=3000
      - ADMIN_EMAIL=sunhao.java@gmail.com
      - DB_SERVER=mongo
      - DB_NAME=yapi
      - DB_PORT=27017
    restart: always
    ports:
      - 3000:3000
    volumes:
      - ~/data/yapi/log/yapi.log:/home/vendors/log
    depends_on:
      - mongo
    entrypoint: "bash /wait-for-it.sh mongo:27017 -- entrypoint.sh"
    networks:
      - back-net
  mongo:
    image: mongo
    container_name: mongo
    restart: always
    ports:
      - 27017:27017
    volumes:
      - ~/data/yapi/mongodb:/data/db
    networks:
      - back-net
networks:
  back-net:
    external: true
```

## Nginx 配置
```
server {
    listen     80;
    server_name your.domain;
    keepalive_timeout   70;

    location / {
        proxy_pass http://yapi:3000;
    }
    location ~ /\. {
        deny all;
    }
}
```

## 启动方法

1. 修改`docker-compose.yml`文件里面相关参数

2. 创建network：`docker network create back-net`

3. 启动服务：`docker-compose up -d`


## 其他
📧联系[@sunhao.java](mailto:sunhao.java@gmail.com)

✨欢迎 Star && Fork