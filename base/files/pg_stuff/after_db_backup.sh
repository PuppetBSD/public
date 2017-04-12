#!/bin/sh

[ -d /tmp/db_dump ] && /bin/rm -rf /tmp/db_dump/*

if [ -d /srv/gitbackups/ ]; then
	/bin/rm -rf /srv/gitbackups/
fi
