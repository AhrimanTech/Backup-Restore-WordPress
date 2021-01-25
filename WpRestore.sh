#!/bin/bash

BKP=/home/ahriman/Documents/backup/

echo "> Script de restauration WordPress"
echo "> Les Backups se trouvent dans le dossier : /home/ahriman/Documents/backup/"
echo "> Entrer la date du fichier à restaurer"

CHECK=$(sudo ls "$BKP" | grep -o -P '(?<=wpbackup_).*(?=.tar.gz)')
echo "> Liste des backups : $CHECK"

while read date
do
        if [ "$date" == "$CHECK" ]
        then
                read -p "> Vous allez restaurer le fichier à partir de wpbackup_"$date".tar.gz`echo $'\n> '` Veuillez confirmer par O/N :" on
                case $on in
                [Oo]* ) tar -zxvf "$BKP"wpbackup_"$date".tar.gz -C /; break;;
                [Nn]* ) exit;;
                * ) echo "";;
                esac
        else
                echo "Veuillez recommencer avec la bonne date"
                exit 1
        fi
done;