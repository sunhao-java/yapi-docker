FROM node:13.13.0-stretch
LABEL maintainer=sunhao<sunhao.java@gmail.com>

# YAPI的版本号
ARG YAPI_VERSION

ENV HOME        	"/home"
ENV GIT_URL     	https://github.com/YMFE/yapi.git
ENV GIT_MIRROR_URL  https://gitee.com/mirrors/YApi.git

# set pwd to yapi home dir
WORKDIR ${HOME}

COPY entrypoint.sh /bin
COPY config.json ${HOME}

# install nodejs
RUN export PORT=3000 && \
	export ADMIN_EMAIL=sunhao.java@gmail.com && \
	export EMAIL_ENABLE=false && \
	export NOTIFY_UPGRADE=true && \
	export DISABLE_REGISTER=false && \
	# 安装 yapi-cli 和 ykit
	npm install -g --registry https://registry.npm.taobao.org ykit && \
	# yapi源码仓库
	ret=`curl -s  https://api.ip.sb/geoip | grep China | wc -l` && \
    if [ $ret -ne 0 ]; then \
        GIT_URL=${GIT_MIRROR_URL} && npm config set registry https://registry.npm.taobao.org; \
    fi; \
	echo ${GIT_URL} && \
	git clone ${GIT_URL} vendors && \
	cd vendors && \
	git fetch origin v${YAPI_VERSION}:v${YAPI_VERSION} && \
	git checkout v${YAPI_VERSION} && \
	# 钉钉插件
	npm install --registry https://registry.npm.taobao.org yapi-plugin-dingding && \
	# yapi自定义导入swagger数据
	npm install --registry https://registry.npm.taobao.org yapi-plugin-import-swagger-customize && \
	# 安装依赖
	npm install --registry https://registry.npm.taobao.org --production && \
	ykit pack -m && \
	chmod +x /bin/entrypoint.sh

EXPOSE ${PORT}
ENTRYPOINT ["entrypoint.sh"]
