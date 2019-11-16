FROM alpine
RUN apk add -U openjdk8 \
    && mkdir -p callersbane \
    && wget -q -P callersbane https://download.scrolls.com/callersbane/server/CallersBane-Server-2.0.1.zip \
    && unzip -q -d callersbane callersbane/CallersBane-Server-2.0.1.zip \
    && rm callersbane/CallersBane-Server-2.0.1.zip \
    && rm -rf /var/cache/apk/*
EXPOSE 8081-8082
VOLUME /callersbane/CallersBane-Server/cfg
CMD ["/bin/sh","-c","java -Dio.netty.epollBugWorkaround=true -Dscrolls.mode=PROD -Dscrolls.node.id=$SERVER_ID -jar /callersbane/CallersBane-Server/Server.jar"]
