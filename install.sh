#!/bin/bash


#Install script for Virgita Backup tool
CurrentDir="$(dirname $0)"

#Make some directories
mkdir -p /opt/nsoporte/virgita_backup_tool/bin
mkdir -p /opt/nsoporte/virgita_backup_tool/lib
mkdir -p /opt/nsoporte/virgita_backup_tool/config
mkdir -p /opt/nsoporte/virgita_backup_tool/cron

#Copy files
cp -v $CurrentDir/virgita_backup_tool.sh /opt/nsoporte/virgita_backup_tool/bin/
cp -v $CurrentDir/functions.sh /opt/nsoporte/virgita_backup_tool/lib/

if [ ! -f /opt/nsoporte/virgita_backup_tool/config/virgita.conf ];then 
	cp -v $CurrentDir/virgita.conf /opt/nsoporte/virgita_backup_tool/config/
else
	cp -v $CurrentDir/virgita.conf /opt/nsoporte/virgita_backup_tool/config/virgita.conf.new
fi

#Fixing permissions
chmod +x /opt/nsoporte/virgita_backup_tool/bin/virgita_backup_tool.sh
chmod +x /opt/nsoporte/virgita_backup_tool/lib/functions.sh



exit 0


