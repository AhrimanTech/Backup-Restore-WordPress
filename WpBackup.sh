#!/bin/bash

BKP=/home/ahriman/Documents/backup/
WP=/var/www/wordpress/

# AWK : Langage script pour le traitement de fichier
# -F : définit le séparateur '
# {print$4} : Imprime le texte entre le 3ème et 4ème séparateur '
BDUSER=$(grep DB_USER $WP/wp-config.php | awk -F\' '{print$4}')
BDNAME=$(grep DB_NAME $WP/wp-config.php | awk -F\' '{print$4}')
BDPASSWORD=$(grep DB_PASSWORD $WP/wp-config.php | awk -F\' '{print$4}')
BDDUMP="$BKP""$BDNAME"_$(date +"%Y-%m-%d-%H-%M").sql

# Informations sur le serveur distant
RUSER=ahriman
RHOST=192.168.0.1
RDIR=/home/ahriman/backup/
RSSHPORT=22
RPASSWORD=root

# mysqldump : Sert à écrire un fichier contenant toutes les directives SQL permettant de recréer une base de données à l’identique de l’état dans lequel elle se trouvait au moment de la sauvegarde
# --no-tablespaces : Cette option supprime toutes les instructions CREATE LOGFILE GROUP et CREATE TABLESPACE dans la sortie de mysqldump
mysqldump --no-tablespaces -u$BDUSER -p$BDPASSWORD $BDNAME > $BDDUMP

tar -czvf "$BKP"wpbackup_$(date +"%Y-%m-%d_%H-%M").tar.gz $WP $BDDUMP

#-------------------------------------------------------------
# Vous pouvez choisir entre RSYNC ou SFTP
#-------------------------------------------------------------

# RSYNC ================================================================================================
# apt-get install sshpass --> Permet d'utiliser automatiquement la connection SSH dans le script
# Désactive le StrictHostKeyChecking (Pour désaciver le vérification de clé d'hôte)
# L'option -a Récursivité :
#       Copie des liens symboliques en tant que liens symboliques
#       Préservation des permissions
#       Préservation des dates de modifications
#       Préservation du groupe
#       Préservation du propriétaire
#       Transfert des fichiers spécifiques
# L'option -z Compression :
#       Permet de compresser le dossier avant l'envoi
# L'option -O :
#       Indique à rsync d'omettre les répertoires lorsque les dates de modification sont préservées (Si les répertoires du destinataire sont partagés via NFS)
#>>>>>>>>>>>>>>>
#rsync -az -O $BKP -e "sshpass -p $RPASSWORD ssh -o StrictHostKeyChecking=no -p $RSSHPORT" $RUSER@$RHOST:$RDIR
#>>>>>>>>>>>>>>>

# SFTP =================================================================================================
# apt-get install lftp --> Est un client FTP permettant facilement en ligne de commande de faire des transferts de fichiers
#>>>>>>>>>>>>>>>
lftp sftp://$RUSER:$RPASSWORD@$RHOST  -e "mirror -R $BKP $RDIR; bye" -u $RUSER,$RPASSWORD $RHOST
#>>>>>>>>>>>>>>>