#!/bin/sh

# This script makes a 7-zip backup of the "Workspace" subfolder
# that 'clone-repositories.sh' creates and stores it in a separate "Backup" folder.
# The only dependency is p7zip.


# Check folder:

if [ ! -d "Workspace" ]; then
    echo The Workspace folder does not exist. Use clone-repositories.sh to recreate it.
    exit 1
fi


# Create backup folder when needed:

mkdir -p "Backup"


# Backup folder and file name, timestamped with the unix date program:

FOLDER="Backup"
FILEPATH="Backup Workspace - $(date "+%Y.%m.%d - %H.%M.%S")".7z


# Create the backup and verify integrity:

7z a "$FOLDER/$FILEPATH" "Workspace" | grep -v "^Compressing"
7z t "$FOLDER/$FILEPATH" | grep -v "^Testing"


# Show the last available backups, sorted by date:

echo
echo -e "\e[1mAvailable backups:\e[0m"
ls -tr "$FOLDER" | tail

