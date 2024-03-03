#!/bin/bash

# Enhanced Backup Script

# Backup settings
SOURCE="/"
DESTINATION="/run/media/aidan/Clips/LinuxBackup/TUF_FX505DT"
LOG_FILE="/var/log/backup.log"
EXCLUDE_FILE="/tmp/backup_exclude.txt"

# Generate dynamic exclude list
cat << EOF > $EXCLUDE_FILE
/dev/*
/proc/*
/sys/*
/tmp/*
/run/*
/mnt/*
/media/*
/lost+found
/home/*/.cache
/home/*/.cargo
/home/*/Downloads
/home/*/.local/share/Trash
/home/*/.npm
/home/*/.nv
/home/*/.nvidia-settings-rc
/home/*/.steam
/home/*/.local/share/Steam  # Exclude Steam cache and data
/home/*/.yarn
/home/*/snap
/home/*/.rustup
/home/*/Documents
/home/*/Music
/home/*/Pictures
/home/*/Videos
/home/*/Templates
/home/*/Public
/home/*/.ssh
/home/*/.gnupg
/home/*/Desktop
/home/*/.gitconfig
/home/*/.bash_history
/home/*/.zsh_history
/home/*/.viminfo
/home/*/wallpapers
/home/*/sounds
/home/*/reports
# Additional exclusions based on provided structure
/home/aidan/.local/share/Steam
/home/*/.local/share/albert
/home/*/.local/share/flatpak
/home/*/.local/share/gnome-settings-daemon
/home/*/.local/share/gnome-shell
/home/*/.local/share/gvfs-metadata
/home/*/.local/share/icons
/home/*/.local/share/iwctl
/home/*/.local/share/komorebi
/home/*/.local/share/man
/home/*/.local/share/midori
/home/*/.local/share/nemo
/home/*/.local/share/nvim
/home/*/.local/share/pipx
/home/*/.local/share/ranger
/home/*/.local/share/recently-used.xbel
/home/*/.local/share/spotify-launcher
/home/*/.local/share/Trash
/home/*/.local/share/vulkan
/home/*/.local/share/xorg
/home/*/.local/share/zsh
/home/*/.local/state
EOF

# Start backup
echo "----------------------------------------" | tee -a $LOG_FILE
echo "Backup started at $(date)" | tee -a $LOG_FILE
echo "----------------------------------------" | tee -a $LOG_FILE

# Running rsync
rsync -rtDhv --no-links --exclude-from=$EXCLUDE_FILE $SOURCE $DESTINATION | tee -a $LOG_FILE

# Check if rsync command was successful
if [ $? -eq 0 ]; then
    echo "----------------------------------------" | tee -a $LOG_FILE
    echo "Backup completed successfully at $(date)" | tee -a $LOG_FILE
    echo "----------------------------------------" | tee -a $LOG_FILE
else
    echo "----------------------------------------" | tee -a $LOG_FILE
    echo "Backup failed at $(date)" | tee -a $LOG_FILE
    echo "----------------------------------------" | tee -a $LOG_FILE
    exit 1
fi

# Generate and display backup summary
echo "Backup Summary:" | tee -a $LOG_FILE
rsync --dry-run -rtDhv --no-links --exclude-from=$EXCLUDE_FILE $SOURCE $DESTINATION | grep -E "^total size is" | tee -a $LOG_FILE
