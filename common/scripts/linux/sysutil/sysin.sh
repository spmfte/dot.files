#!/bin/zsh

echo "System Information Script"

# CPU Info
echo "CPU Info:"
lscpu | grep "Model name"
echo ""

# GPU Info
echo "GPU Info:"
lspci | grep -E "VGA|3D"
echo ""

# Loaded Kernel Modules
echo "Loaded Kernel Modules:"
lsmod
echo ""

# Display Server
echo "Display Server:"
echo "Xorg Version:"
X -version 2>&1 | grep "X.Org X Server"
echo ""
echo "Wayland Sessions:"
ls /usr/share/wayland-sessions/
echo ""

# Current mkinitcpio Configuration
echo "Current mkinitcpio Configuration:"
cat /etc/mkinitcpio.conf
echo ""

# Current GRUB Configuration
echo "Current GRUB Configuration:"
grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub
echo ""

# Additional System Information
echo "Additional System Information:"
uname -a
echo ""

echo "Script Completed"

