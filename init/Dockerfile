FROM alpine
COPY entry.sh .
RUN apk add -U docker mysql-client \
    && mkdir -p data \
    && mkdir -p init \
    && mkdir -p callersbane \
    && rm -rf /var/cache/apk/* \
    && wget -q -P callersbane https://download.scrolls.com/callersbane/server/CallersBane-Server.zip \
    && unzip -q -d callersbane callersbane/CallersBane-Server.zip \
    && cp callersbane/CallersBane-Server/cfg/hibernate.cfg.xml init/ \
    && cp callersbane/callersbane_database.sql init/  \
    && rm -rf callersbane
VOLUME /data
CMD ["/bin/sh","entry.sh"]
