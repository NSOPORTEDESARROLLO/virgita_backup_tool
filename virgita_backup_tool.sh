#!/bin/bash


#Virgita Backup Tool


. virgita.conf

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

#Backup Directories
for i in ${BackupDirs//,/ };do
	
	Backup=$(printf  "%s "  "$Backup $i")

done

#Append backup directory to exclude list
Exclude="$Exclude --exclude=$BackupTo/*"



FULL_COMMAND_GZ="tar -cvf /file.tgz $Exclude $Backup"




echo "$FULL_COMMAND_GZ"






