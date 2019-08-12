#!/bin/bash


#Virgita Backup Tool


. virgita.conf


#System Globals
TarPath=$(which tar);if [ "$TarPath" = "" ];then echo "ERROR: I can not find tar command.";exit 1;fi
HostName=$(hostname)
DaTe=$(date +%d-%m-%Y)
FullName="FULL-$HostName-$DaTe"
DiffName="DIFF-$HostName-$DaTe"
FullBackupTo="$BackupTo/$HostName"


#Create backup Directory if not exists 
if [ ! -d $FullBackupTo ];then
	mkdir -p $FullBackupTo
fi



#System excludes
SysEx="/proc,/dev,/sys,/tmp"
Exclude=""
for i in ${SysEx//,/ };do
	
	Exclude=$(printf  "%s "  "$Exclude --exclude=$i/*")

done

#User excludes
for i in ${UserExclude//,/ };do
	
	Exclude=$(printf  "%s "  "$Exclude --exclude=$i/*")

done

#User exclude extensions
for i in ${UserExcludeExt//,/ };do
	
	Exclude=$(printf  "%s "  "$Exclude --exclude="\'*.$i\'"")

done



#Backup Directories
for i in ${BackupDirs//,/ };do
	
	Backup=$(printf  "%s "  "$Backup $i")

done

#Append backup directory to exclude list
Exclude="$Exclude --exclude=$BackupTo/*"



echo "$TarPath -czvf $FullBackupTo/$FullName.tgz $Exclude  $Backup"
$TarPath -czvf $FullBackupTo/$FullName.tgz $Exclude  $Backup







