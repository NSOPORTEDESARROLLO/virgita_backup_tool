#!/bin/bash


#Virgita Backup Tool
SCRIPT=`realpath $0`
SCRIPTPATH=`dirname $SCRIPT`

if [ -f "$SCRIPTPATH/virgita.conf" ];then

	. $SCRIPTPATH/virgita.conf

else 

	echo "Error: No encuentro el archivo de configuracion virgita.conf"
	exit 1

fi


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
if [ -f "$SCRIPTPATH/functions.sh" ];then

	. $SCRIPTPATH/functions.sh

else

	echo "Error: No encuentro el archivo de funciones"
	exit 1

fi


###### Run Database backups #####
if [ "$MysqlBackups" = "yes" ];then
	#Run Mysql Backup
	BackupMysql
	Backup="$Backup $MDIR"

fi


######Backup Boot System
if [ "$MBRDUMP" != "" ];then
	DumpMbr
fi


#Check for first time backup
if [ ! -f "$IncFile" ];then
	echo "No existe un backup FULL aun, creando el primer FULL"
	DOFULL
	CleanFiles
	exit 0
fi


#If Today is FULL
if [ "$DayOfWeek" = "$ToDay" ];then
	DOFULL
	CleanFiles
	exit 0
fi


#If DOFULL Forced
if [ "$MoDe" = "DOFULL" ];then 
	DOFULL
	CleanFiles
	exit 0
fi


#If it still does not match then run DODIFF
DODIFF
CleanFiles
exit 0
















