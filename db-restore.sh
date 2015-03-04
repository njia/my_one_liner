#!/bin/bash

DB_HOST='cst-cgxdb01'
BASE_DB='_cleargrain_com_au_prod'
UAT_DB="rhuat${BASE_DB}"
BETA_DB="rhbeta${BASE_DB}"
DB_NAME=''

DB_RESTORE_LOG_DIR=/tmp/DB_RESTORE_LOG
DB_RESTORE_LOG="${DB_RESTORE_LOG_DIR}/mysql-restore.`date +%F:%H:%M`"
DB_BACKUP_FILE_DIR='/misc/share/databases/prod_backups/'

function debug_out() {
  TIMESTAMP=$(date "+%F:%H:%M")
  printf "\t<<< DEBUG >>> %s : $*\n" ${TIMESTAMP} | tee -a ${DB_RESTORE_LOG}
}

function die() {
  printf "$*\n"
  exit 1
}

# Post to slack
function post_to_slack() {
  SLACK_HOSTNAME="nzx.slack.com"
  SLACK_TOKEN="mHIzLLXYgvczcrJUdWN3jWDa"
  SLACK_CHANNEL="#cgx"
  SLACK_BOTNAME="mysql"

  printf "$*\n"
  curl -s -X POST --proxy 10.3.70.71:3128 --data "payload={\"channel\": \"${SLACK_CHANNEL}\", \"username\": \"${SLACK_USERNAME}\", \"text\": \"${ICON} Message: $*\" }" https://${SLACK_HOSTNAME}/services/hooks/incoming-webhook?token=${SLACK_TOKEN}

  if [[ $? != 0 ]]; then
    debug_out "Could not post to slack"
  fi
}

# check if DB already exist
function checkDB() {
  debug_out "Check to see if ${DB_NAME} alread exist"
  result=$(mysqlshow -h "${DB_HOST}" -u clear -pzq12wxce34rv | grep -w "${DB_NAME}")
  if [[ -n ${result} ]]; then
    dropDB
  fi
  createDB
}

function dropDB() {
  debug_out "Dropping DB ${DB_NAME}"
  mysqladmin -h "${DB_HOST}" -u clear -pzq12wxce34rv -f drop "${DB_NAME}"
  if [[ $? != 0 ]]; then
    die "Could not drop DB ${DB_NAME}"
  fi
}

function createDB() {
  debug_out "Creating DB ${DB_NAME}"
  mysqladmin -h ${DB_HOST} -u clear -pzq12wxce34rv create ${DB_NAME}

  if [[ $? != 0 ]]; then
    die "Failed to recreate DB ${DB_NAME}"
  fi
  debug_out "DB ${DB_NAME} successfully created"
}

# Reset DB password
function reset_password() {
  DIR="/usr/local/www/rails_apps/$1.cleargrain.com.au/current/"
  cd ${DIR}
  RAILS_ENV="$1" bundle exec rake db:reset_all_passwords
  if [[ $? != 0 ]]; then
    post_to_slack "Had problem to reset password"
  else
    post_to_slack "Reset all password completed"
  fi
}

function restoreDB() {
  post_to_slack "Starting restore to $1"
  /bin/gunzip -c "${DB_BACKUP_FILE_DIR}${DB_FILE}" | pv -n -s $(gzip -l "${DB_BACKUP_FILE_DIR}${DB_FILE}" | perl -lane 'print $F[1]+2**32 if eof') | mysql -u clear -pzq12wxce34rv -h "${DB_HOST}" "${DB_NAME}" &> "${DB_RESTORE_LOG}"

  if [[ $? != 0 ]]; then
    post_to_slack "DB restore failed\n"
    post_to_slack "$(cat ${DB_RESTORE_LOG})"
    exit 1
  fi
}

if [[ ! -d ${DB_RESTORE_LOG_DIR} ]]; then
  printf "%s\n" "MySQL restore log directory does not exist, will try to create\n"
  mkdir -p ${DB_RESTORE_LOG_DIR}
  if [[ $? != 0 ]]; then
    printf "%s\n" "Could not create log directory ${DB_RESTORE_LOG_DIR}"
    exit 1
  fi
fi

touch "${DB_RESTORE_LOG}"

if [[ $? != 0 ]]; then
  printf "%s\n" "Could not create DB resotre log file"
  exit 1
fi

if [[ "${USER}" != 'clear' ]]; then
  die "Please run this script as user clear"
fi

if [ -z $1 ]; then
  die "Usage: $0 [rhuat|rhbeta]\n"
fi

case $1 in
    'rhuat')
    DB_NAME="${UAT_DB}"
    ;;
    'rhbeta')
    DB_NAME="${BETA_DB}"
    ;;
    *)
    die "Unknow selectin --> $1"
    ;;
esac

debug_out "${DB_NAME} selected for DB restore"

DB_FILE=$(ls -rtw 1 ${DB_BACKUP_FILE_DIR} | tail -1)

if [[ -z ${DB_FILE} ]]; then
  die "No backup file found"
fi

debug_out "Latest DB backup file is ${DB_FILE}"
checkDB
restoreDB $1
reset_password $1
post_to_slack "DB restored"

exit 0
