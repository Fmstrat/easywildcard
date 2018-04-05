#!/bin/sh

if [ ! -d /tmp/easywildcard ]; then
	mkdir -p /tmp/easywildcard
fi

echo "${CERTBOT_DOMAIN}" > /tmp/easywildcard/DOMAIN
echo "${CERTBOT_VALIDATION}" >> /tmp/easywildcard/VALIDATION

NUM=$(< /tmp/easywildcard/VALIDATION wc -l)
if [ $NUM -eq 2 ]; then
	/hooks/start-dns.sh
fi
