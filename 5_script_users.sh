#!/bin/bash

# ------------------------------------------------------------------->
# Script : 4_script_sshd.sh
# Auteur : Alexy Despres
# Description : Defini une bannière SSH
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

# Chemin vers le fichier users_liste
userList="files/users.liste"
# Chemin vers le fichier sudoers
sudoersFile="files/mysudoers"

# Lire chaque ligne du fichier des users
while IFS=: read -r username password; do
    # Créer l'utilisateur
    log "Creating user $username"
    useradd "$username" 2>> "$logFile"

    # Définir le mot de passe de l'utilisateur
    log "Setting passwd for $username"
    echo "$username:$password" | chpasswd 2>> "$logFile"

    # Expirer le mot de passe
    log "Expiring passwd for $username"
    chage -d 0 "$username" 2>> "$logFile"
done < "$userList"

# Configurer le fichier sudoer
log "Configuring sudoer file..."
while IFS= read line; do
    if ! grep -q "$line" /etc/sudoers; then
        echo "$line" >> /etc/sudoers 2>> "$logFile"
    fi
done < "$sudoersFile"

log "Exécution complétée"

exit 0
