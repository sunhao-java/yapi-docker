FROM node:13.13.0-stretch
LABEL maintainer=sunhao<sunhao.java@gmail.com>

# YAPI的版本号
ARG YAPI_VERSION

ENV HOME        	"/home"
ENV PORT        	3000
ENV ADMIN_EMAIL 	"sunhao.java@gmail.com"
ENV DB_HOST	 		"localhost"
ENV DB_NAME 		"yapi"
ENV DB_PORT 		27017
ENV DB_USER			"yapi"
ENV DB_PWD			"yapi"
ENV EMAIL_ENABLE	"false"
ENV VENDORS 		${HOME}/vendors
ENV GIT_URL     	https://github.com/YMFE/yapi.git
ENV GIT_MIRROR_URL  https://gitee.com/mirrors/YApi.git

# set pwd to yapi home dir
WORKDIR ${HOME}

COPY entrypoint.sh /bin
COPY config.json ${HOME}

# install nodejs
RUN ret=`curl -s  https://api.ip.sb/geoip | grep China | wc -l` && \
    if [ $ret -ne 0 ]; then \
        GIT_URL=${GIT_MIRROR_URL} && npm config set registry https://registry.npm.taobao.org; \
    fi; \
	echo ${GIT_URL} && \
	git clone ${GIT_URL} vendors && \
	cd vendors && \
	git fetch origin v${YAPI_VERSION}:v${YAPI_VERSION} && \
	git checkout v${YAPI_VERSION} && \
	npm install --production && \
	chmod +x /bin/entrypoint.sh

EXPOSE ${PORT}
ENTRYPOINT ["entrypoint.sh"]
