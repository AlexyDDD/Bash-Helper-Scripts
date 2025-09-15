#!/bin/bash

# -----------------------------------------------------------------------------
# Script : 1_script_addr_ip.sh
# Auteur : Alexy Despres
# Description : Configure un address IP statique et le DNS
# Paramètres : <adresse_IP/masque> <gateway> <DNS>
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
#--------------------------------------------------------------------#

# Vérification du nombre de paramètres
if [ "$#" -ne 3 ]; then
    log "Nombre de parametres incorrect"
    echo "Usage: $0 <adresse_IP/masque> <gateway> <DNS>" # Message d'erreur
    exit 1
fi

# Paramètres --> Variables
address_IP="$1"
gateway="$2"
DNS="$3"

# Interface et connection
log "Detection interface"
interface=$(nmcli -t -f DEVICE dev status | head -n 1)
if [ -z "$interface" ]; then
	log "No interface found"
	exit 1
fi

log "Detecting connection"
connection=$(nmcli -t -f NAME,DEVICE con show | grep "$interface" | cut -d: -f1)
interface=$(nmcli -t -f DEVICE dev status | head -n 1)
if [ -z "$connection" ]; then 
        log "No connection found"
        exit 1
fi

log "Interface : $interface"
log "Connection : $connection"

# Configuration de l'adresse IP statique en utilisant nmcli
log "Switching to manual method"
nmcli con mod "$connection" ipv4.method manual 2>> "$logFile"

log "Configuration le l'address IP : $address_IP"
nmcli con mod "$connection" ipv4.addresses "$address_IP" 2>> "$logFile"

log "Configuration du gateway : $gateway"
nmcli con mod "$connection" ipv4.gateway "$gateway" 2>> "$logFile"

log "Configuration du DNS : $DNS"
nmcli con mod "$connection" ipv4.dns "$DNS" 2>> "$logFile"

# Application des modifications
log "Application des modifications"
nmcli con up "$connection" 2>> "$logFile"

log "Exécution complétée"

# On quitte le programme
exit 0
