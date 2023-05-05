#!/bin/bash

# Get the list of saved Wi-Fi networks
IFS=$'\n'
networks=($(networksetup -listpreferredwirelessnetworks en0 | tail -n +2))

echo "List of saved Wi-Fi networks:"

# Display the list of networks
for network in "${networks[@]}"; do
    echo "$network"
done

# Prompt user to enter the network name
echo "Enter the network name:"
read network_name

# Run the security command to get the password
password=$(security find-generic-password -wa "$network_name" 2>/dev/null)

if [ -n "$password" ]; then
    echo "Network: $network_name | Password: $password"
else
    echo "Network: $network_name | Password: Not Found"
fi

