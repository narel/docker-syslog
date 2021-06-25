FROM alpine:latest
LABEL maintainer="czachorowski.karol@gmail.com"

RUN apk add --no-cache syslog-ng logrotate less shadow

VOLUME ["/var/log"]

RUN adduser -D loguser
ADD syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
COPY crontab /etc/crontabs/root
COPY run.sh /run.sh
RUN chmod 640 /etc/crontabs/root && chmod 755 /run.sh

EXPOSE 514/tcp 514/udp
ENV LOGFILE_PERM 0640
ENV RUN_UID 1000
ENV RUN_GID 1000
ENV ROTATE_NUM 366
ENV ROTATE_FREQUENCY daily

CMD exec /run.sh
