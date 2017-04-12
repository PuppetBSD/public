#!/bin/sh

if [ -e /usr/local/bin/gitolite_backup.sh ]; then
	/usr/local/bin/gitolite_backup.sh
fi

if [ -e /etc/init.d/mongodb ]; then
	/etc/init.d/mongodb status
	if [ $? -eq 0 ]; then
		cd /tmp/db_dump && /usr/bin/mongodump
	fi
fi

if hash pg_lsclusters 2>/dev/null; then
	postgres_version=$( pg_lsclusters -h | head -n 1 | awk '{print $1}' )
	postgres_status=$( pg_lsclusters -h | head -n 1 | awk '{print $4}' )
	postgres_owner=$( pg_lsclusters -h | head -n 1 | awk '{print $5}' )
	pg_backup_path="/tmp/db_dump/pg_backup"
	pg_test_config="/usr/local/etc/pg_backup.conf"
	TS=$(date +%Y%m%d_%H%M%S)
	if  [ -d $pg_backup_path ]; then
		/bin/rm -rf $pg_backup_path
	fi

	if [ $postgres_status = "online" ]; then
		if [ $postgres_version = "9.2" ]; then
			/bin/su - $postgres_owner -c "mkdir -p -m 700 $pg_backup_path; pg_basebackup -D  $pg_backup_path --checkpoint=fast --xlog-method=fetch -l $TS"
		else
			/bin/su - $postgres_owner -c "mkdir -p -m 700 $pg_backup_path; pg_basebackup -D  $pg_backup_path --xlog -l $TS"
		fi

		/bin/su - $postgres_owner -c "/bin/cp /etc/postgresql/$postgres_version/main/pg_hba.conf $pg_backup_path/"
		/bin/su - $postgres_owner -c "/bin/cp /etc/postgresql/$postgres_version/main/pg_ident.conf $pg_backup_path/"
		/bin/su - $postgres_owner -c "/usr/lib/postgresql/$postgres_version/bin/postgres -D $pg_backup_path -c config_file=$pg_test_config > /tmp/postgres 2>&1 &"
		sleep 10
		/bin/su - $postgres_owner -c "/usr/lib/postgresql/$postgres_version/bin/pg_ctl -D $pg_backup_path status && /usr/lib/postgresql/$postgres_version/bin/pg_ctl -D $pg_backup_path stop && /bin/tar --remove-files -czf /tmp/db_dump/pg_backup.tgz $pg_backup_path"
		if [ $? -ne 0 ]; then
			cat /tmp/postgres
			exit 1
		fi
	fi
fi

if [ -r /root/.my.cnf ]; then
	mysql_password=$( cat /root/.my.cnf| grep -m 1 password | awk -F '=' '{print $2}' )
	/usr/bin/mysqladmin -u root -p$mysql_password ping 2>/dev/null 1>/dev/null
	if [ $? -eq 0 ] && [ -z "`mysql -u root -p$mysql_password -e "show master status"`" ]; then
		/usr/bin/nice -10 /usr/bin/mysqldump -u root -p$mysql_password --routines --single-transaction -A | /usr/bin/nice -10 gzip > /tmp/db_dump/mysql.sql.gz
	fi

	/usr/bin/mysqladmin -u root -p$mysql_password -S /tmp/mysql_sandbox10000.sock ping 2>/dev/null 1>/dev/null
	if [ $? -eq 0 ] && [ -z "`mysql -u root -p$mysql_password -S /tmp/mysql_sandbox10000.sock -e "show master status"`" ]; then
		/usr/bin/mysql -u root -p$mysql_password -S /tmp/mysql_sandbox10000.sock -e "slave stop"
		/usr/bin/nice -n 19 /usr/bin/mysqldump -u root -p$mysql_password -S /tmp/mysql_sandbox10000.sock --routines --single-transaction -A | /usr/bin/pv -L 4m |/usr/bin/nice -n 19 gzip > /tmp/db_dump/mysql_sandbox10000.sql.gz
		/usr/bin/mysql -u root -p$mysql_password -S /tmp/mysql_sandbox10000.sock -e "slave start"
	fi
fi

#redis backup
if [ -x /usr/bin/redis-cli ];then
	if /usr/bin/redis-cli ping; then
		/bin/cp -r /var/lib/redis /tmp/db_dump/
	fi
fi
