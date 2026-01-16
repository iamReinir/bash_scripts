#!/bin/bash

# Define variables
SWAP_DIR="$HOME/path"
SWAP_FILE="$SWAP_DIR/swapfile"
SWAP_SIZE="8G"

# Create the directory if it doesn't exist
mkdir -p "$SWAP_DIR"

# Create the swapfile
echo "Creating $SWAP_SIZE swapfile at $SWAP_FILE..."
fallocate -l $SWAP_SIZE "$SWAP_FILE" || dd if=/dev/zero of="$SWAP_FILE" bs=1M count=8192 status=progress

# Set the correct permissions
chmod 600 "$SWAP_FILE"

# Format the file as swap
mkswap "$SWAP_FILE"

# Enable the swap
sudo swapon "$SWAP_FILE"

# Verify swap is active
echo "Swap status:"
swapon --show

# Add entry to /etc/fstab if not already present
FSTAB_ENTRY="$SWAP_FILE none swap defaults 0 0"
if ! grep -Fxq "$FSTAB_ENTRY" /etc/fstab; then
    echo "Adding swap entry to /etc/fstab..."
    echo "$FSTAB_ENTRY" | sudo tee -a /etc/fstab > /dev/null
else
    echo "Swap entry already exists in /etc/fstab."
fi

echo "Swap setup complete."

