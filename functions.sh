#!/bin/bash


SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

if [ -f "$SCRIPTPATH/virgita.conf" ];then

	. $SCRIPTPATH/virgita.conf

else 

	echo "Error: No encuentro el archivo de configuracion virgita.conf"
	exit 1

fi


########### Functions
function DumpMbr () {

	if [ ! -d "/var/spool/virgita/boot" ];then
		mkdir -p /var/spool/virgita/boot
	fi

	dd if=$MBRDUMP of=/var/spool/virgita/boot/mbr.mbr bs=466 count=1




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



function CleanFiles () {

	$FindPath  $FullBackupTo/* -mtime +$DaysToKeep -exec rm {} \;
	rm -rf /var/spool/virgita


}


function DOFULL () {

	#Do full backup

	rm -f $IncFile
	if [ "$Compress" = "yes" ];then
		COMMNAD="$TarPath czvp -g $IncFile -f $FullBackupTo/$FullName.tgz $Exclude $Backup"
	else 
		COMMNAD="$TarPath cvp -g $IncFile -f $FullBackupTo/$FullName.tar $Exclude $Backup" 
	fi

	$COMMNAD > /dev/null
	exit 0


}


function DODIFF () {

	#Do differential backup
	if [ "$Compress" = "yes" ];then		
		COMMNAD="$TarPath czvp -g $IncFile -f $FullBackupTo/$DiffName.tgz $Exclude $Backup"
	else
		COMMNAD="$TarPath cvp -g $IncFile -f $FullBackupTo/$DiffName.tar $Exclude $Backup"
	fi

	$COMMNAD > /dev/null
	exit 0

}
