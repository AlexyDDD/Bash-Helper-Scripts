#!/bin/bash

# ------------------------------------------------------------------->
# Script : 10_script_principale.sh
# Auteur : Alexy Despres
# Description : Appel tout les scripts
# Paramètres : All
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

#!/bin/bash

min=0
max=3

# Vérifier le nombre d'arguments
if [[ $# -lt $min || $# -gt $max ]]; then
    log "Nombre de parametres incorrect"
    exit 1
fi

# Exécuter les scripts 1 à 8 avec les paramètres fournis
for i in {1..8}; do
    script_name=$(ls "${i}_script_"* 2>/dev/null | head -n 1)

    if [[ -n "$script_name" && -x "$script_name" ]]; then
        log "Exécution de $script_name avec paramètres : $*"
        ./"$script_name" "$@"
    else
        log "Avertissement : Script pour $i non trouvé ou non exécutable."
    fi
done

log "Exécution complétée"

exit 0
