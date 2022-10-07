#!/bin/sh

ENDPOINTS_FILE=/monitor-list

if [ "${ENDPOINTS+1}" ]; then
  echo "$ENDPOINTS" >> "$ENDPOINTS_FILE"
elif [ ! -f $ENDPOINTS_FILE ];then
  echo "Missing ENDPOINTS variable or $ENDPOINTS_FILE file"
  exit 1
fi

if [ "${SEND_EMAIL+1}" ]; then
  if [ ! "${SMTP_URI+1}" ] || \
     [ ! "${SMTP_USER+1}" ] || \
     [ ! "${SMTP_TO+1}" ] || \
     [ ! "${SMTP_PASS+1}" ]; then
    echo "SEND_EMAIL option requires SMTP_USER, SMTP_PASS, SMTP_TO and SMTP_URI to be set"
    exit 1
  fi
  : ${SMTP_FROM:=ssl-cert-check@localhost.localdomain}
eval "cat > ~/.mailrc << EOF
$(cat /tmp/mailrc.template)
EOF"
  EMAIL_OPTIONS=" -a -e $SMTP_TO"
fi

: ${WARNING_DAYS_MAX:=30}
: ${WARNING_DAYS_MIN:=-1}
command="/ssl-cert-check -f $ENDPOINTS_FILE -x $WARNING_DAYS_MAX -y $WARNING_DAYS_MIN -z $CHAT_API $EMAIL_OPTIONS"

while true;
do
  if [ "${WEEKLY_TIME+1}" ]; then
    now=$(date +%s)
    next=$(date -d "next ${WEEKLY_TIME}" +%s)
    diff=$((next - now))
    echo "Waiting for next run which is set for $WEEKLY_TIME ($diff seconds)"
    echo "Sleeping $diff seconds -OR- $((diff / 60)) minutes -OR- $((diff / 3600)) hours -OR- $((diff / 86400)) days for next execution"
    sleep $diff
    $command
  elif [ "${DAILY_TIME+1}" ]; then
    now=$(date +%s)
    next=$(date -d "today ${DAILY_TIME}" +%s)
    if [ $next -lt $now ]; then
      next=$(date -d "tomorrow ${DAILY_TIME}" +%s)
    fi
    diff=$((next - now))
    echo "Sleeping $diff seconds for next execution"
    sleep $diff
    $command
  elif [ "${CHECK_INTERVAL+1}" ]; then
    $command
    echo "Sleeping $CHECK_INTERVAL seconds for next execution"
    sleep $CHECK_INTERVAL
  else
    $command
    exit 0
  fi
done