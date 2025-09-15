#!/bin/bash

# -----------------------------------------------------------------------------
# Script : 2_script_hosts.sh
# Auteur : Alexy Despres
# Description : Change le hostname de la machine
# Paramètres : <FQDN>
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

# Vérifier que le paramètre est fourni
if [ "$#" -ne 1 ]; then
    log "Nombre de parametres incorrect"
    echo "Erreur : Veuillez fournir un FQDN comme paramètre."
    exit 1
fi

# Paramètre --> Variable
FQDN=$1

# Backups de /etc/hostname et /etc/hosts avec extension .bak (pour backup)
log "Backing up /etc/hostname and /etc/hosts"
cp /etc/hostname /etc/hostname.bak 2>> "$logFile"
cp /etc/hosts /etc/hosts.bak 2>> "$logFile"

# Modifier le fichier /etc/hostname
log "Editing /etc/hostname"
echo "$FQDN" > /etc/hostname 2>> "$logFile"

# Modifier le fichier /etc/hosts
log "Editing /etc/hosts"
sed -i "s/$(hostname)/$FQDN/g" /etc/hosts 2>> "$logFile"

# Appliquer le changement de nom
log "Setting the hostname"
hostnamectl set-hostname "$FQDN" 2>> "$logFile"

log "Exécution complétée"

exit 0
