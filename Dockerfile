FROM certbot/certbot

ENTRYPOINT [ "/getcert.sh" ]
VOLUME /etc/letsencrypt /var/lib/letsencrypt
WORKDIR /opt/certbot

COPY hooks /hooks
COPY getcert.sh /getcert.sh

RUN apk --update add bind

EXPOSE 53
