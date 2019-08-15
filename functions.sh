#!/bin/bash


. /home/christopher/Documentos/GitHub/virgita_backup_tool/virgita.conf



function BackupMysql () {

	DumpPath=$(which mysqldump)
    if [ "$DumpPath" = "" ];then
    	echo "ERROR: mysqldump missing install it for Full Mysql Backup"
 		exit 1
 	fi	




}





########### Functions
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
