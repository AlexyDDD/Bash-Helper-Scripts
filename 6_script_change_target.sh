#!/bin/bash

# ------------------------------------------------------------------->
# Script : 6_script_change_target.sh
# Auteur : Alexy Despres
# Description : Changer l affichage
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

if [ "$#" -ne 0 ]; then
    log "Nombre de parametres incorrect"
    exit 1
fi

# Obtenir le niveau d'exécution actuel
log "Getting current target"
currentTarget=$(systemctl get-default) 2>> "$logFile"

# Déterminer le nouveau niveau d'exécution
if [[ "$currentTarget" == "graphical.target" ]]; then
    newTarget="multi-user.target"
    log "Passage en mode multi-utilisateur."
elif [[ "$currentTarget" == "multi-user.target" ]]; then
    newTarget="graphical.target"
    log "Passage en mode graphique."
else
    log "Le niveau d'exécution actuel ($currentTarget) n'est ni graphique ni multi-utilisateur. Aucun changement effectué."
    exit 1
fi

# Changer le niveau d'exécution
log "Passage en cours"
systemctl set-default "$newTarget" 2>> "$logFile"

# Redémarrer le système
log "Redémarrage du système pour appliquer les changements..."
shutdown -r now 2>> "$logFile"

log "Exécution complétée"

exit 0
