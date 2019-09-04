#!/bin/bash


. /opt/nsoporte/virgita_backup_tool/config/virgita.conf



########### Functions

function DockerBackup () {

	if [ -d $DockerBackupTo ];then
		rm -rfv $DockerBackupTo
	fi

	mkdir -p $DockerBackupTo

	DockerPath=$(which docker)

	if [ ! -f $DockerPath ];then
		echo "ERROR: I can not find Docker service."
		exit 1 
	fi


	for i in ${DockerLists//,/ };do
	
		$DockerPath save $i -o $		

	done






}









function BackupMysql () {


	MysqlClient=$(which mysql)
 	MysqlDump=$(which mysqldump)
	
    if [ "$MysqlDump" = "" ];then
    	echo "ERROR: mysqldump missing install it for Full Mysql Backup"
 		exit 1
 	fi	

  	if [ "$MysqlClient" = "" ];then
    	echo "ERROR: Mysql Client missing install it for Full Mysql Backup"
 		exit 1
 	fi	

 	echo "Mysql Backups enabled"

	if [ -d $MDIR ];then
		rm -rf $MDIR
	fi

	mkdir -p $MDIR

	databases=$($MysqlClient -u root -p$MSQLPWD -h $MSQLHOST -e "SHOW DATABASES;" | tr -d "| " | grep -v "+---" |grep -Ev "(Database|information_schema|performance_schema|mysql)" )


	for db in $databases;do

		file="$MDIR/$db.sql"
		#echo $file
		$MysqlDump -u root -p$MSQLPWD -h $MSQLHOST  "$db" > "$file"



	done



}



function DELOLD () {

	$FindPath  $FullBackupTo/* -mtime +$DaysToKeep -exec rm {} \;



}


function DOFULL () {

	#Do full backup

	rm -f $IncFile
	if [ "$Compress" = "yes" ];then
		COMMNAD="$TarPath czvp -g $IncFile -f $FullBackupTo/$FullName.tgz $Exclude $Backup"
	else 
		COMMNAD="$TarPath cvp -g $IncFile -f $FullBackupTo/$FullName.tar $Exclude $Backup"
	fi

	$COMMNAD
	$DELOLD
	exit 0


}


function DODIFF () {

	#Do differential backup
	if [ "$Compress" = "yes" ];then		
		COMMNAD="$TarPath czvp -g $IncFile -f $FullBackupTo/$DiffName.tgz $Exclude $Backup"
	else
		COMMNAD="$TarPath cvp -g $IncFile -f $FullBackupTo/$DiffName.tar $Exclude $Backup"
	fi

	$COMMNAD
	$DELOLD
	exit 0

}
