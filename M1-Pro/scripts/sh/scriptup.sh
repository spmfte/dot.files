#!/bin/zsh

# Configuration
SCRIPTS_DIR="$HOME/scripts"
SCRIPTS_DIR_BAK="$HOME/scripts_bak"
SCRIPTS_DIR_REPO="$HOME/dot.files/M1-Pro/scripts"
REPO_DIR="$HOME/dot.files"
LOG_FILE="$HOME/dot.files/scriptsup.log"

# Function to log messages
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Create backup of scripts directory
if rsync -av --delete "$SCRIPTS_DIR/" "$SCRIPTS_DIR_BAK/"; then
  log_message "Backup of scripts directory created successfully."
else
  echo "Failed to create scripts directory backup. Exiting."
  exit 1
fi

# Synchronize scripts directory to the repository
if rsync -av --delete "$SCRIPTS_DIR/" "$SCRIPTS_DIR_REPO/"; then
  log_message "scripts directory updated in the repository."
else
  echo "Failed to update scripts directory in the repository. Exiting."
  exit 1
fi

# Determine commit message
COMMIT_MSG="Update scripts directory (automated)"
if [ $# -gt 0 ]; then
  COMMIT_MSG="$*"
fi

# Commit and push changes
cd "$REPO_DIR" || exit
if [[ `git status --porcelain` ]]; then
  if git add . && git commit -m "$COMMIT_MSG" && git push; then
    log_message "Changes pushed to repository successfully with message: $COMMIT_MSG"
    echo "Changes pushed to repository successfully."
  else
    echo "Failed to push changes to repository."
    exit 1
  fi
else
  log_message "No changes to commit."
  echo "No changes to commit."
fi

echo "Done!"

# Cross-platform auditory feedback
if [[ "$OSTYPE" == "darwin"* ]]; then
  say -v Han\ \(Premium\) Your vim configuration files are uh have been uploaded uh successfully
else
  echo "Your script files have been updated and uploaded successfully."
fi
