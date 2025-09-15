#!/bin/bash

# ------------------------------------------------------------------->
# Script : 9_script_personnel.sh
# Auteur : Alexy Despres
# Description : Utilise nmap et classifi sont output
# Paramètres : Address IP / masque
# Date : 2025-02-06
# ------------------------------------------------------------------->

#--------------------------------------------------------------------#

sudo -v

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
    echo "Erreur : Veuillez fournir un subnet comme paramètre."
    exit 1
fi

# Paramètre --> Variable
subnet=$1

# Vérifie si Nmap est installé
if ! command -v nmap &> /dev/null; then
    echo "Erreur: Nmap n'est pas installé. Installe-le avec: sudo apt install nmap"
    exit 1
fi

echo " Scan du réseau : $subnet..."
echo "----------------------------------------------------"

# Scanne le réseau pour détecter les appareils
nmapOutput=$(sudo nmap -sn "$subnet" 2>> "$logFile")

# Boucle pour afficher chaque appareil
echo "$nmapOutput" | grep -E "Nmap scan report|MAC Address" | while read -r line; do
    if echo "$line" | grep -q "Nmap scan report"; then
        # Extract IP and name
	name=$(echo "$line" | sed 's/Nmap scan report for \([^ ]*\) .*/\1/' 2>> "$logFile")
        ip=$(echo "$line" | sed 's/.*(\([^)]*\)).*/\1/' 2>> "$logFile")
    elif echo "$line" | grep -q "MAC Address"; then
        # Extract MAC and vendor
        mac=$(echo "$line" | sed 's/MAC Address: \([^ ]*\) .*/\1/' 2>> "$logFile")
        vendor=$(echo "$line" | sed 's/.*(\([^)]*\)).*/\1/' 2>> "$logFile")
        # Print the result
        echo "Name: $name | IP: $ip | MAC: $mac | Fabricant: $vendor"
    fi
done

echo "----------------------------------------------------"
echo "Scan terminé."

log "Exécution complétée"

exit 0

