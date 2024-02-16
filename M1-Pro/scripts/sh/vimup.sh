#!/bin/zsh

# Configuration
VIMRC="$HOME/.vimrc"
VIMRC_BAK="$HOME/.vimrc.bak"
VIMRC_REPO="$HOME/dot.files/common/vim/.vimrc"
REPO_DIR="$HOME/dot.files"
LOG_FILE="$HOME/dot.files/vimup.log"

# Function to log messages
log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Backup .vimrc
if cp "$VIMRC" "$VIMRC_BAK"; then
  log_message "Backup of .vimrc created successfully."
else
  echo "Failed to create .vimrc backup. Exiting."
  exit 1
fi

# Update .vimrc in the repository
if cp "$VIMRC" "$VIMRC_REPO"; then
  log_message ".vimrc updated in the repository."
else
  echo "Failed to update .vimrc in the repository. Exiting."
  exit 1
fi

# Determine commit message
COMMIT_MSG="Update .vimrc (automated)"
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

say -v Han\ \(Premium\) Your files are uh have been uploaded uh successfully
