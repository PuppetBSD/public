#!/bin/bash
set -e
set -u

if [ -z "$*" ]; then
	echo "Give me message"
	exit 1
fi

DT=$( date "+[%Y-%m-%d %H:%M:%S]" )
MSG="$*"

res=$( curl -X POST --data-urlencode "payload={\"channel\": \"#server_alerts\", \"username\": \"devbot\", \"text\": \"${DT} $*\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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 )
#res=$( curl -X POST --data-urlencode "payload={\"channel\": \"#frontend_deploy\", \"username\": \"devbot\", \"text\": \"${DT} $*\", \"icon_emoji\": \":ghost:\"}" https://hooks.slack.com/services/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 )

echo '${res}'
