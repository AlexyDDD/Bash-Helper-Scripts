#!/bin/bash

# ------------------------------------------------------------------->
# Script : 8_script_install_app.sh
# Auteur : Alexy Despres
# Description : Install des apps a partir d'un fichier et d'un parametres
# Paramètres : web ou ftp
# Date : 2025-02-06
# ------------------------------------------------------------------->

#--------------------------------------------------------------------#

# Création du répertoire de logs
dir="$(dirname "$0")/log"
mkdir -p "$dir"

# Génération du fichier log avec time
scriptName=$(basename "$0")
time=$(date +"%Y%m%d_%H%M%S")
logFile="$dir/${scriptName}_${time}.log"

# Fonction de log
log() {
    echo "$(date +"%Y-%m-%d %H:%M:%S") - $1" >> "$logFile"
}

# Début du script
log "Exécution démarrée"

#--------------------------------------------------------------------#

if [ "$#" -ne 0 ]; then
    log "Nombre de parametres incorrect"
    exit 1
fi

# Chemin vers le fichier contenant la liste des paquets
packageList="files/packages.liste"

# Installer les paquets listés dans le fichier
log "Installation des paquets listés dans $packageList..."
xargs -a "$packageList" apt-get install -y 2>> "$logFile"

# Vérifier les paramètres pour installer des paquets supplémentaires
if [[ "$1" == "ftp" ]]; then
    log "Installation du paquet vsftpd et configuration pour le démarrage automatique..."
    apt-get install -y vsftpd 2>> "$logFile"
    systemctl enable vsftpd 2>> "$logFile"
    systemctl start vsftpd 2>> "$logFile"
elif [[ "$1" == "web" ]]; then
    log "Installation du paquet httpd (Apache) et configuration pour le démarrage automatique..."
    apt-get install -y apache2 2>> "$logFile"
    systemctl enable apache2 2>> "$logFile"
    systemctl start apache2 2>> "$logFile"
elif [[ -n "$1" ]]; then
    log "Paramètre non reconnu : $1. Aucun paquet supplémentaire installé."
fi

log "Exécution complétée"

exit 0
