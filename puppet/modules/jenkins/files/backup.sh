#!/bin/sh
# Back up and upload Jenkins data

BACKUP_PATH=/backup

DAY="`date +%u`"



tar zcfP ${BACKUP_PATH}/jenkins_backup${DAY}.tgz --exclude=workspace --exclude=*.priv --exclude=.ssh --exclude=*.key  /var/lib/jenkins/
rsync -a /backup/* vault.FIXME-FIXME.org::cidev_bkup/
