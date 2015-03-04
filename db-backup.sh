#!/bin/bash

# This script is to backup mysql databases and you should not need to modif
# this script unless there is a bug.
# check /etc/default/clearservices for all the configurable variables.

# mysqldump error log file name and location, don't want this to be configurable
DUMP_LOG_DIR='/tmp/MYSQLDUMP'
DUMP_LOG=${DUMP_LOG_DIR}/mysqldump-`date +%F:%H:%M`

if [ ! -d "${DUMP_LOG_DIR}" ]; then
  debug_out "${DUMP_LOG_DIR} does not exist"
  exit 1
fi

CONFIG='/etc/default/clearservices'

if [[ ! -r "${CONFIG}" ]];
then
  alert "Config file ${CONFIG} does not exist or not readable."
  exit 1
fi

# Read config file
. ${CONFIG}

# if backup directory does not exist, stop
if [ ! -d  "${DB_BACKUP_DIR}" ];
then
  alert "Backup directory ${DB_BACKUP_DIR} does not exist"
  exit 1
fi

# Mysql user info
MY_CNF='/root/.my.cnf'

if [[ ! -r "${MY_CNF}" ]];
then
  alert "Could not get mysqldump login details!"
  exit 1
else
  MYSQLDUMP_USER=`awk -F"=" '/user/ {print $NF}' ${MY_CNF}`
  MYSQLDUMP_PASS=`awk -F"=" '/password/ {print $NF}' ${MY_CNF}`
fi

# name of symlink to latest completed backup (not actual backup file)
CURRENT_SYMLINK='latest-backup.sql.gz'

# Mailx command and related options
MAILER=`which mailx`
MAILER_OPENTIONS=''

# timestamped echo()
function debug_out() {
  TIMESTAMP=`date +%H:%M:%S`
  echo "$TIMESTAMP:" $* | tee -a ${DUMP_LOG}
}

# prefixed echo to stderr, basically
function warn() {
  echo "WARNING:" $*  2>&1 | tee -a ${DUMP_LOG}
}

# similar to warn(), but also aborts execution
function die() {
  echo "ERROR:" $*  2>&1 | tee -a ${DUMP_LOG}
  exit 1
}

function alert() {
  echo  -e "$* \\n `cat ${DUMP_LOG}`" | ${MAILER} -s "Mysql backup failed!" ${MAILER_OPTIONS} ${ALERT_EMAIL}
  die ""
}

function notify() {
  echo -e "$* \\n `ls -l ${DB_BACKUP_DIR}/${DUMP_FILE}.gz`" | ${MAILER} -s "Mysql backup finished successfully!" ${MAILER_OPTIONS} ${NOTIFICATION_EMAIL}
}

function print_details() {
  debug_out "MySQL server:               ${DB_HOST}"
  debug_out "Databases included:         ${DB_NAME}"
  debug_out "Databases backup directory: ${DB_BACKUP_DIR}"
  debug_out "Alert email sent to:        ${ALERT_EMAIL}"
  debug_out "Notification email send to: ${NOTIFICATION_EMAIL}"
  debug_out "Database files older than ${PRUNE_DAYS} days will be removed"
  debug_out "Database backup logs older than ${DUMP_LOG_PRUNE_DAYS} days will be removed"
  debug_out "MySQL dump command and options: ${MYSQLDUMP} ${DUMP_OPTIONS}"
  debug_out "Mysql dump username : ${MYSQLDUMP_USER}"
}

# define DB backup file name and actually dump databases
DATESTAMP=`date '+%Y%m%d_%H%M'`
DUMP_FILE="CGX-DB.$DATESTAMP.sql"
GZIP='/bin/gzip'

debug_out "DB dump started"

${MYSQLDUMP} ${DUMP_OPTIONS} ${DB_NAME} --log-error=${DUMP_LOG} -h ${DB_HOST} -u${MYSQLDUMP_USER} -p${MYSQLDUMP_PASS} > ${DB_BACKUP_DIR}/${DUMP_FILE}
RETVAL=$?

if [ $RETVAL -eq 0 ]; then
  debug_out "DB dumped sucessfully"
else
  print_details
  alert "Failed to dump DB, please see log file ${DUMP_LOG} for details"
fi

${GZIP} ${DB_BACKUP_DIR}/${DUMP_FILE}
RETVAL=$?

if [ $RETVAL -eq 0 ]; then
  debug_out "DB dump file compressed sucessfully"
else
  alert "Failed to compress DB, please see log file ${DUMP_LOG} for details"
fi

# update symlink, removing old one if it exists
cd ${DB_BACKUP_DIR}
if [ -L "${CURRENT_SYMLINK}" ]; then
  rm "${CURRENT_SYMLINK}"
fi
# failing to update this is cause to abort, because it implies a significant unexpected situation
if ! ln -s "${DUMP_FILE}.gz" "${CURRENT_SYMLINK}"; then
    alert "Failed to update current-backup symlink; this is not critical, but still a bad thing!"
fi

# find/delete sufficiently old files
# failing to delete one of these is not cause to abort: it might be a mis-catch (in which case we shouldn't delete it),
#   and there's nothing else to do afterward anyway.
for OLD_FILE in `find ${DB_BACKUP_DIR} -name "CGX*.gz" -mtime +${PRUNE_DAYS}`; do
  debug_out "Found old backup ${OLD_FILE}; deleting..."
  rm -f "${OLD_FILE}"
  # we could warn() if the rm fails, but it'll produce stderr output anyway
done

for OLD_LOGS in `find ${DUMP_LOG_DIR} -name "mysqldump-*" -mtime +${DUMP_LOG_PRUNE_DAYS}`; do
  debug_out "Found old dump log files ${OLD_LOGS}; deleting..."
  rm -f "${OLD_LOGS}"
  # we could warn() if the rm fails, but it'll produce stderr output anyway
done

# If we get here, that means DB backup, zip and link update all finished successfully, notify the users
chown nfsnobody:nfsnobody ${DUMP_FILE}.gz
notify "MySQL db backup finished at `date +%F:%H:%M` backup file compressed and symbloc link updated - DB backup directory is : ${DB_BACKUP_DIR}"

exit 0
