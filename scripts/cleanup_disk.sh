#!/bin/bash

echo "Cleaning up unused packages..."
sudo apt-get autoremove -y
sudo apt-get clean

echo "Clearing system logs..."
sudo journalctl --vacuum-time=1day

echo "Removing old kernels..."
sudo apt-get autoremove --purge -y

echo "Cleaning up Docker resources..."
docker container prune -f
docker image prune -a -f
docker network prune -f
docker volume prune -f
docker system prune -a -f --volumes

echo "Removing unused Snap packages..."
sudo snap list --all | awk '/disabled/{print $1, $3}' | while read snapname revision; do sudo snap remove "$snapname" --revision="$revision"; done

echo "Clearing thumbnail cache..."
rm -rf ~/.cache/thumbnails/*

echo "Removing temporary files..."
sudo rm -rf /tmp/*

echo "Checking disk usage for specified directories..."
directories=(
    "/var/log"
    "/home"
    "/tmp"
    "/var/lib/docker"
)

for dir in "${directories[@]}"; do
    echo "Disk usage for $dir:"
    du -sh "$dir"
    echo ""
done

echo "Finding the largest files and directories..."
sudo du -ah / | sort -rh | head -n 20

echo "Disk cleanup completed."