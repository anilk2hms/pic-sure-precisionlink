#!/bin/bash



export PSAMA_SETTINGS_VOLUME=""
export PICSURE_SETTINGS_VOLUME=""

if [ ! $DOCKER_CONFIG_DIR ] ; then 
    export DOCKER_CONFIG_DIR="/usr/local/docker-config" 
fi 

export APP_ID=`cat $DOCKER_CONFIG_DIR/APP_ID_RAW`
export RESOURCE_ID=`cat  $DOCKER_CONFIG_DIR/RESOURCE_ID_RAW`
export AUTH0_CLIENT_ID=`cat $DOCKER_CONFIG_DIR/httpd/psamaui_settings.json | grep client_id | cut -d ":" -f 2 | sed 's/\",*//g'`

sed -i "s/__STACK_SPECIFIC_APPLICATION_ID__/$APP_ID/g" ui/src/main/webapp/picsureui/settings/settings.json
sed -i "s/__STACK_SPECIFIC_RESOURCE_UUID__/$RESOURCE_ID/g" ui/src/main/webapp/picsureui/settings/settings.json
sed -i "s/__AUTH0_CLIENT_ID__/$AUTH0_CLIENT_ID/g" ui/src/main/webapp/psamaui/settings/settings.json

if ! cmp -s "$DOCKER_CONFIG_DIR/httpd/psamaui_settings.json" "ui/src/main/webapp/psamaui/settings/settings.json"  ; then
	cp ui/src/main/webapp/psamaui/settings/settings.json $DOCKER_CONFIG_DIR/httpd/psamaui_settings.json
fi

if ! cmp -s "$DOCKER_CONFIG_DIR/httpd/picsureui_settings.json" "ui/src/main/webapp/psamaui/picsureui/settings.json"  ; then
	cp ui/src/main/webapp/picsureui/settings/settings.json $DOCKER_CONFIG_DIR/httpd/picsureui_settings.json
fi


if ! cmp -s "$DOCKER_CONFIG_DIR/httpd/httpd-vhosts.conf" "ui/httpd-vhosts.conf"  ; then
	cp ui/httpd-vhosts.conf $DOCKER_CONFIG_DIR/httpd/httpd-vhosts.conf
fi


