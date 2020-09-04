#! /bin/bash
cd ${VENDORS}
if [ ! -e "${HOME}/init.lock" ]
then
	sed -i "s/DIY-PORT/"${PORT}"/g" ${HOME}/config.json
	sed -i "s/DIY-AC/"${ADMIN_EMAIL}"/g" ${HOME}/config.json
	sed -i "s/DIY-DB-HOST/"${DB_HOST}"/g" ${HOME}/config.json
	sed -i "s/DIY-DB-NAME/"${DB_NAME}"/g" ${HOME}/config.json
	sed -i "s/DIY-DB-PORT/"${DB_PORT}"/g" ${HOME}/config.json
	sed -i "s/DIY-DB-USER/"${DB_USER}"/g" ${HOME}/config.json
	sed -i "s/DIY-DB-PWD/"${DB_PWD}"/g" ${HOME}/config.json

	_EMAIL_ENABLE="false"
	if [[ "true" == "${EMAIL_ENABLE}" ]]; then
		_EMAIL_ENABLE="true"
	fi
	sed -i "s/DIY-MAIL-ENABLE/"${_MAIL_ENABLE}"/g" ${HOME}/config.json
	sed -i "s/DIY-MAIL-HOST/"${MAIL_HOST}"/g" ${HOME}/config.json
	sed -i "s/DIY-MAIL-PORT/"${MAIL_PORT}"/g" ${HOME}/config.json
	sed -i "s/DIY-MAIL-FROM/"${MAIL_FROM}"/g" ${HOME}/config.json
	sed -i "s/DIY-MAIL-USER/"${MAIL_USER}"/g" ${HOME}/config.json
	sed -i "s/DIY-MAIL-PWD/"${MAIL_PWD}"/g" ${HOME}/config.json

	cp ${HOME}/config.json ${VENDORS}
	cd ${VENDORS}
	# 安装程序会初始化数据库索引和管理员账号，管理员账号名可在 config.json 配置
	npm run install-server
fi

node server/app.js