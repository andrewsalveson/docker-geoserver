#!/bin/bash
PORT=8081
REST=http://localhost:"${PORT}"/geoserver/rest/
USER=admin
PASS=geoserver
ADDR="${REST}"
XML=''
case "$2" in
	workspace)
		ADDR="${ADDR}"workspaces
		XML='<workspace><name>'"$3"'</name></workspace>'
		;;
	user)
		# every user gets a layerGroup
		ADDR="${ADDR}"workspaces/public/layergroups
		XML='<layerGroup><name>'"$3"'</name>'$(cat layers.xml)$(cat workspace.xml)$(cat bounds.xml)$(cat publishables.xml)$(cat styles.xml)'</layerGroup>'
		;;
esac
echo $ADDR
echo $XML
case "$1" in
	add)
		curl -u "${USER}":"${PASS}" -v \
			-XPOST -H 'Content-type:text/xml' \
			-d "${XML}" \
			"$ADDR"
		;;
	get)
		curl -u "${USER}":"${PASS}" -v \
			-XGET -H 'Accept: text/xml' \
			"${ADDR}"/"${3}".xml
		;;
	del)
		curl -u "${USER}":"${PASS}" -v \
			-XDELETE -H 'Accept: text/xml' \
			"${ADDR}"/"${3}"
		;;
esac
