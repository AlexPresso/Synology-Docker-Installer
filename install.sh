#!/bin/bash

###############################
# VARS
###############################

kernel=$(uname -s)
arch=$(uname -m)
baseDownloadUrl="https://download.docker.com/linux/static/stable/$arch"


###############################
# FUNCTIONS
###############################

function info {
	echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}


###############################
# DOCKER INSTALLATION
###############################

info "NAS kernel: $kernel, NAS architecture: $arch"

info "Preparing to install docker..."
info "Fetching latest docker $arch version..."
latest=$(curl --silent "$baseDownloadUrl/" | grep -oP 'href="docker-\K[0-9]+\.[0-9]+\.[0-9]' | sort -t. | tail -1)
status=$?

if [ $status -ne 0 ]; then
	info "No docker version found for your NAS architecture ($arch)."
	exit 1
fi

filename="docker-$latest.tgz"
info "Downloading $filename ..."
wget -q -O - "$baseDownloadUrl/$filename" > "/tmp/$filename"

info "Unpacking $filename ..."
tar xzf "/tmp/$filename" -C /tmp
cp "/tmp/docker/*" /usr/bin

info "Creating docker directory outside DSM..."
mkdir -p /volume1/@Docker/lib

info "Mounting docker directory to /docker"
mkdir /docker
mount -o bind "/volume1/@Docker/lib" /docker

info "Injecting /etc/docker/deamon.json configuration"
echo '{
	"storage-driver": "vfs",
	"iptables": false,
	"bridge": "none",
	"data-root": "/docker"
}
' > /etc/docker/daemon.json

info "Running docker daemon..."
dockerd &

info "Done installing docker $latest."

###############################
# DOCKER-COMPOSE INSTALLATION
###############################

info "Installing docker-compose..."
info "Fetching latest docker-compose version..."
latestCompose=$(curl --silent "https://api.github.com/repos/docker/compose/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
status=$?

if [ $status -ne 0 ]; then
	info "Cannot find latest docker-compose version"
	exit 1
fi

filename="docker-compose-$kernel-$arch"
info "Downloading $filename $latestCompose ..."
curl --silent -L "https://github.com/docker/compose/releases/download/$latestCompose/$filename" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

info "Done installing docker-compose $latestCompose"
