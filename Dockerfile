FROM centos:6.6
MAINTAINER Dmitriy Gorchakov "dmitry.gorchakov@red-soft.ru"

ARG RELEASE=2.6.0
ARG BUILD=13276
ARG ARCH=x86_64
ARG RELEASE_URL=http://builds.red-soft.biz/release_hub/rdb26/$RELEASE.$BUILD/download/red-database:linux-$ARCH:$RELEASE.$BUILD:tar.gz:cs

WORKDIR /

RUN yum install -y xinetd tar \
 && mkdir -p /opt/RedDatabase \
 && echo "URL: $RELEASE_URL" \
 && curl -s -L -o /tmp/rdb.tar.gz -O "$RELEASE_URL" \
 && tar -xf /tmp/rdb.tar.gz -C /opt/RedDatabase \
 && rm -rf /tmp/rdb.tar.gz \
 && touch /opt/RedDatabase/firebird.log

ADD firebird /etc/xinetd.d
ADD SYSDBA.password /opt/RedDatabase
ADD docker-entrypoint.sh /
ADD alias.py /

VOLUME /data

EXPOSE 3050/tcp
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["tail -f /opt/RedDatabase/firebird.log"]