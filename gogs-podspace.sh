#!/bin/bash

REPO_ROOT="/data/repositories"
RUN_USER="git"
LOG_ROOT_PATH="/data/log"
DB_PATH="/data/db/gogs.db"
GOGS="/opt/gogs/gogs"
APP_URL=""

: ${ADMIN_USERNAME:="gogs"}
: ${ADMIN_PASSWORD:="admin"}
: ${ADMIN_EMAIL:="admin@" }

mkdir -p /data/repositories
mkdir -p /data/log
mkdir -p /data/db

# Kill background processes on exit
trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
s
# Start up GOGS 
$GOGS web &
# Wait until it starts up
while ! curl -s http://localhost:3000 > /dev/null; do echo "[PODSPACE] Waiting for GOGS to start up..."; sleep 3; done

# Check if it redirects to /install
REDIRECT=$(curl -I -X GET http://localhost:3000/ 2>/dev/null|grep 'Location:'|cut -d ' ' -f 2|tr -d '[:space:]')
if [ "$REDIRECT" == "/install" ]; then
  # TODO Test for the HTTP status code of the install call, and fail if it was not successfull
  echo "[PODSPACE] Executing installation..."
  curl 'http://localhost:3000/install' -H 'Content-Type: application/x-www-form-urlencoded' --data 'db_type=SQLite3&db_host=127.0.0.1%3A3306&db_user=root&db_passwd=&db_name=gogs&ssl_mode=disable&app_name=Gogs%3A+Go+Git+Service&ssh_port=22&http_port=3000&smtp_host=&smtp_from=&smtp_email=&smtp_passwd=&enable_captcha=on&admin_name=&admin_passwd=&admin_confirm_passwd=&admin_email=' --data-urlencode run_user=${RUN_USER} --data-urlencode repo_root_path=${REPO_ROOT} --data-urlencode log_root_path=${LOG_ROOT_PATH} --data-urlencode db_path=${DB_PATH} --data-urlencode app_url=${APP_URL} --data-urlencode domain=${APP_URL}
  echo "[PODSPACE] Creating the admin user..."
  $GOGS admin create-user --name ${ADMIN_USERNAME} --password ${ADMIN_PASSWORD} --email ${ADMIN_EMAIL} --admin || (echo "[PODSPACE] Failed to create admin user." && exit 1)
fi

echo "[PODSPACE] Initialization complete."

sleep infinity
