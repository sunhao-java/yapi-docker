FROM node:13.13.0-stretch
LABEL maintainer=sunhao<sunhao.java@gmail.com>

# YAPI的版本号
ARG YAPI_VERSION

ENV HOME        		/home/yapi
ENV GIT_URL     		https://github.com/YMFE/yapi.git
ENV GIT_MIRROR_URL  	https://gitee.com/mirrors/YApi.git
ENV PORT            	3000
ENV ADMIN_EMAIL			sunhao.java@gmail.com
ENV EMAIL_ENABLE		false
ENV DISABLE_REGISTER	false

# set pwd to yapi home dir
WORKDIR ${HOME}

COPY entrypoint.sh /bin
COPY config.json ${HOME}

# install nodejs
# yapi源码仓库
RUN ret=`curl -s  https://api.ip.sb/geoip | grep China | wc -l` && \
    if [ $ret -ne 0 ]; then \
        GIT_URL=${GIT_MIRROR_URL} && npm config set registry https://registry.npm.taobao.org; \
    fi; \
	echo ${GIT_URL} && \
	git clone ${GIT_URL} vendors && \
	cd vendors && \
	git fetch origin v${YAPI_VERSION}:v${YAPI_VERSION} && \
	git checkout v${YAPI_VERSION} && \
	# 安装依赖
	npm install --registry https://registry.npm.taobao.org --production && \
	chmod +x /bin/entrypoint.sh

VOLUME ["${HOME}"]
EXPOSE ${PORT}
ENTRYPOINT ["entrypoint.sh"]
