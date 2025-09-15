#!/bin/bash

# -----------------------------------------------------------------------------
# Script : 3_script_update.sh
# Auteur : Alexy Despres
# Description : Fait un update du system
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

log "Mise à jour du système en cours..."
sudo apt update 2>> "$logFile"
sudo apt upgrade -y 2>> "$logFile"

log "Exécution complétée"

exit 0
