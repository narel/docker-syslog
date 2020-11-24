#!/bin/sh
set -e

chmod 755 /var/log

usermod --non-unique --uid $RUN_UID loguser
groupmod --non-unique --gid $RUN_GID loguser

cat << EOF > /etc/logrotate.conf
/var/log/*.log
{ 
    rotate ${ROTATE_NUM}
    ${ROTATE_FREQUENCY}
    missingok
    create 644 loguser loguser
    notifempty
    compress
    postrotate
        pkill -HUP syslog-ng > /dev/null
    endscript
}
EOF
chmod 640 /etc/logrotate.conf

crond

exec /usr/sbin/syslog-ng -F -f /etc/syslog-ng/syslog-ng.conf --no-caps
