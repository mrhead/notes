#!/bin/sh

heroku pgbackups:capture
curl -o db_backups/`date "+%Y%m%d"`.dump `heroku pgbackups:url`
