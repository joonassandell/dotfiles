#!/bin/bash
# https://github.com/rmmgc/vscode-extensions-bulk-install/tree/main

# Colors used for logs
NC='\033[0m'          # Reset color
GREEN='\033[0;32m'    # Green color
RED='\033[0;31m'      # Red color

print_green () {
  message=$1
  printf "${GREEN}${message}${NC}\n"
}

print_red () {
  message=$1
  printf "${RED}${message}${NC}\n"
}

# Check for cursor command
# Cursor must be installed for script to work properly
if ! command -v cursor &> /dev/null
then
    print_red "Could not detect code command on your system.\n❌ Aborting."

    printf "💡 Check if Cursor is properly installed.\n"
    printf "💡 Make sure to add "$(print_green code)" command to the PATH\n"
    exit 1
fi

# Check if provided file exists
EXTENSIONS_FILE_PATH="$1"
if [ ! -f "$EXTENSIONS_FILE_PATH" ]; then
  print_red "File, on path $EXTENSIONS_FILE_PATH, could not be found.\n❌ Aborting."
  exit 1
fi

# File is expected to be in .txt format
if [[ "$EXTENSIONS_FILE_PATH" != *.txt ]]; then
  print_red "File, on path $EXTENSIONS_FILE_PATH, does not have correct format.\n❌ Aborting."
  printf "💡 Make sure that provided file has $(print_green .txt) extension/format.\n"
  exit 1
fi

# Get currently installed extensions
INSTALLED_EXTENSIONS=$(cursor --list-extensions)

# Loop over file contents line by line and try to install extensions
while read -r extension_name; do
  printf "🔧 Working on "$(print_green $extension_name)" extension.\n"

  if [[ $INSTALLED_EXTENSIONS == *"$extension_name"* ]]; then
    printf "✅ Extension already installed.\nSkipping further steps.\n\n"
    continue
  fi

  printf "Running: cursor --install-extension "$extension_name".\n"
  cursor --install-extension "$extension_name"

  if [ $? -eq 0 ]; then
    print_green "✅ Extension installed successfully.\n"
  else
    print_red "❌ Extension installation failed."
    printf "💡 Check the logs above to get more informations about error.\n\n"
  fi
done < "$EXTENSIONS_FILE_PATH"

printf "💡 Check the logs above for detailed report.\n"
print_green "🎉 Successfully finished."
