#!/bin/bash

# -----------------------------------------------------------------------------
# Script : 4_script_sshd.sh
# Auteur : Alexy Despres
# Description : Defini une bannière SSH
# Paramètres : None
# Date : 2025-02-06
# -----------------------------------------------------------------------------

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

# Fichier de bannière relatif
relativeBannerFile="files/my_issue"

# Ficher de banniere absolue
log "Creating path..."
scriptDir="$(dirname "$(realpath "$0")")"
bannerFile="$scriptDir/$relativeBannerFile"

# Fichier de configuration SSH
config="/etc/ssh/sshd_config"

log "Deleting previous banner"
sed -i "/^#*Banner/d" "$config" 2>> "$logFile"

log "Setting up new bannner"
echo "Banner $bannerFile" >> "$config" 2>> "$logFile"

log "Restarting ssh"
# J'ai trouver avec systemctl -l --type service --all|grep ssh que, pour moi, le service est ssh et non sshd
systemctl restart ssh 2>> "$logFile" 

log "Exécution complétée"

exit 0
