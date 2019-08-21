#!/bin/bash


#Virgita Backup Tool


. /home/christopher/Documentos/GitHub/virgita_backup_tool/virgita.conf


#System Globals
TarPath=$(which tar);if [ "$TarPath" = "" ];then echo "ERROR: I can not find tar command.";exit 1;fi
HostName=$(hostname)
FindPath=$(which find)
DaTe=$(date +%d-%m-%Y)
FullName="FULL-$HostName-$DaTe"
DiffName="DIFF-$HostName-$DaTe"
FullBackupTo="$BackupTo/$HostName"
IncFile="$FullBackupTo/.virgita.snap"
ToDay=$(date +%A)
MoDe="$1"

#Create backup Directory if not exists 
if [ ! -d $FullBackupTo ];then
	mkdir -p $FullBackupTo
fi


#System excludes
SysEx="/proc,/dev,/sys,/tmp"
Exclude=""
for i in ${SysEx//,/ };do
	
	Exclude="$Exclude --exclude=$i/*"

done

#User excludes
for i in ${UserExclude//,/ };do
	
	Exclude="$Exclude --exclude=$i/*"

done

#User exclude extensions
for i in ${UserExcludeExt//,/ };do

	Exclude="$Exclude --exclude=*.$i"
	

done


#Backup Directories
for i in ${BackupDirs//,/ };do
	
	Backup="$Backup $i"

done

#Append backup directory to exclude list
Exclude="$Exclude --exclude=$BackupTo/*"


#Load Functions 
. /home/christopher/Documentos/GitHub/virgita_backup_tool/functions.sh


###### Run Database backups #####
if [ "$MysqlBackups" = "yes" ];then
	#Run Mysql Backup
	BackupMysql
	Backup="$Backup $MDIR"

fi



#If DOFULL Forced
if [ "$MoDe" = "DOFULL" ];then 
	DOFULL 
fi

#If Today is FULL
if [ "$DayOfWeek" = "$ToDay" ];then
	DOFULL
fi


#If it still does not match then run DODIFF
DODIFF
















