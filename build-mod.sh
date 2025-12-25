#!/bin/bash

# Check for folder and author name arguments
if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: ./build-mod.sh <folder_name> <author_name>"
  exit 1
fi

FOLDER_NAME=$1
AUTHOR_NAME=$2

INFO_FILE="$FOLDER_NAME/info.xml"
ARCHIVE_FILE="$FOLDER_NAME.zip"

# Check if folder exists
if [ ! -d "$FOLDER_NAME" ]; then
  echo "Error: Folder '$FOLDER_NAME' does not exist."
  exit 1
fi

# Check if info.xml exists
if [ ! -f "$INFO_FILE" ]; then
  echo "Error: '$FOLDER_NAME' is not a valid MMO mod (missing info.xml)."
  exit 1
fi

# Backup original info.xml
BACKUP_FILE="$INFO_FILE.bak"
cp "$INFO_FILE" "$BACKUP_FILE"

# Update author in info.xml temporarily
sed "s/author=""/author="$AUTHOR_NAME"/" "$INFO_FILE" > "$INFO_FILE.tmp" && mv "$INFO_FILE.tmp" "$INFO_FILE"

# Create a zip archive using PowerShell, excluding the backup file
(cd "$FOLDER_NAME" && powershell.exe -Command "Get-ChildItem -Path '.' -Exclude 'info.xml.bak' | Compress-Archive -DestinationPath '../$ARCHIVE_FILE' -Force")

# Restore original info.xml
mv "$BACKUP_FILE" "$INFO_FILE"

echo "Successfully created $ARCHIVE_FILE with author set to '$AUTHOR_NAME'."

