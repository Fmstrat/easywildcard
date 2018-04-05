#!/bin/sh

cd /opt/certbot

AUTHSERVER="https://acme-v02.api.letsencrypt.org/directory"
if [ -n "${STAGING}" ]; then
	AUTHSERVER="https://acme-staging-v02.api.letsencrypt.org/directory"
fi
if [ -n "${SERVER}" ]; then
	AUTHSERVER=${SERVER}
fi
echo "Using server ${AUTHSERVER}"

if [ -n "${RENEW}" ]; then
	echo "Renewing."
	certbot renew --force-renewal
else
	echo "Getting new cert."
	if [ -z "${DOMAIN}" ]; then echo "Domain mising."; exit; fi
	if [ -z "${EMAIL}" ]; then echo "Email mising."; exit; fi
	certbot certonly --manual --agree-tos --non-interactive --server ${AUTHSERVER} --manual-auth-hook /hooks/auth-hook.sh --manual-public-ip-logging-ok --preferred-challenges=dns --email ${EMAIL} -d ${DOMAIN} -d *.${DOMAIN}
fi
