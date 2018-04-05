#!/bin/sh

DOMAIN=$(cat /tmp/easywildcard/DOMAIN)
echo "Using domain ${DOMAIN}"

echo "Creating named.conf"
echo "options {" > /tmp/easywildcard/named.conf
echo "        directory \"/var/bind\";" >> /tmp/easywildcard/named.conf
echo "        allow-transfer {" >> /tmp/easywildcard/named.conf
echo "                none;" >> /tmp/easywildcard/named.conf
echo "        };" >> /tmp/easywildcard/named.conf
echo "        pid-file \"/var/run/named/named.pid\";" >> /tmp/easywildcard/named.conf
echo "        allow-recursion { none; };" >> /tmp/easywildcard/named.conf
echo "        recursion no;" >> /tmp/easywildcard/named.conf
echo "};" >> /tmp/easywildcard/named.conf
echo "zone \"acme-challenge.${DOMAIN}\" IN {" >> /tmp/easywildcard/named.conf
echo "      type master;" >> /tmp/easywildcard/named.conf
echo "      file \"/tmp/easywildcard/zone.txt\";" >> /tmp/easywildcard/named.conf
echo "};" >> /tmp/easywildcard/named.conf

echo "Creating zone file"
echo "; acme-challenge.${DOMAIN}" > /tmp/easywildcard/zone.txt
echo "\$TTL 60" >> /tmp/easywildcard/zone.txt
echo "@ IN     SOA    acme-dns.${DOMAIN}. dnsmaster@trashmail.com. (" >> /tmp/easywildcard/zone.txt
echo "				2018040201  ; Serial" >> /tmp/easywildcard/zone.txt
echo "				3H          ; refresh after 3 hours" >> /tmp/easywildcard/zone.txt
echo "				1H          ; retry after 1 hour" >> /tmp/easywildcard/zone.txt
echo "				1W          ; expire after 1 week" >> /tmp/easywildcard/zone.txt
echo "				60)         ; minimum TTL of 1 day" >> /tmp/easywildcard/zone.txt
echo "" >> /tmp/easywildcard/zone.txt
echo "	; Name Server" >> /tmp/easywildcard/zone.txt
echo "	IN	NS	acme-dns.${DOMAIN}." >> /tmp/easywildcard/zone.txt
echo "" >> /tmp/easywildcard/zone.txt
for V in $(cat /tmp/easywildcard/VALIDATION); do
	echo "acme-challenge.${DOMAIN}.		IN TXT			${V}" >> /tmp/easywildcard/zone.txt
done
echo "" >> /tmp/easywildcard/zone.txt
echo "; EOF" >> /tmp/easywildcard/zone.txt

echo "Starting bind"
rm -f /etc/bind/named.conf
cp /tmp/easywildcard/named.conf /etc/bind/named.conf
#named -c /tmp/easywildcard/named.conf -u named
named -u named
echo "Bind started"

sleep 10
