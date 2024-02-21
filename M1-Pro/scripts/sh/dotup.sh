#!/bin/zsh

# Configuration
ZSHRC="$HOME/.zshrc"
ALIASRC="$HOME/.alias"
ZSHRC_BAK="$HOME/.zshrc.bak"
ZSHRC_REPO="$HOME/dot.files/M1-Pro/.zshrc"
ALIASRC_REPO="$HOME/dot.files/M1-Pro/.alias"
REPO_DIR="$HOME/dot.files"
LOG_FILE="$HOME/dot.files/dotup.log"

# Function to log messages
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Backup .zshrc
if cp "$ZSHRC" "$ZSHRC_BAK"; then
  log_message "Backup of .zshrc created successfully."
else
  echo "Failed to create .zshrc backup. Exiting."
  exit 1
fi

if cp "$ALIASRC" "$ALIASRC_REPO"; then
  log_message ".aliasrc updated in the repository"
else
  echo "Failed to update .aliasrc in the repository"
  exit 1 
fi

# Update .zshrc in the repository
if cp "$ZSHRC" "$ZSHRC_REPO"; then
  log_message ".zshrc updated in the repository."
else
  echo "Failed to update .zshrc in the repository. Exiting."
  exit 1
fi

# Determine commit message
COMMIT_MSG="Update .zshrc and .alias (automated)"
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

say -v Han\ \(Premium\) Your dot files are uh have been uploaded uh successfully
