#!/bin/bash

# ------------------------------------------------------------------->
# Script : 4_script_sshd.sh
# Auteur : Alexy Despres
# Description : Lock un user
# Paramètres : None
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

# Vérifier si un nom d'utilisateur est fourni
if [[ -z "$1" ]]; then
    log "Nombre de parametres incorrect"
    exit 1
fi

username=$1

# Vérifier si l'utilisateur existe
if id "$username" &>/dev/null; then
    # Désactiver la connexion pour l'utilisateur
    log "Desactivating user : $username"
    usermod -L "$username"
else
    # Enregistrer un message dans le fichier log si le user nexiste pas
    log "L'utilisateur $username n'existe pas."
fi

log "Exécution complétée"

exit 0
