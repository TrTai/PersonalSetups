#!/bin/bash
#sed -i 's/WaylandEnable=false/WaylandEnable=true/g' /etc/gdm3/custom.conf
IFVIRTUALIZATION=false
apt update
add-apt-repository ppa:neovim-ppa/unstable -y
add-apt-repository ppa:flexiondotorg/quickemu -y
if [ ! -f /usr/share/keyrings/microsoft.gpg ]; then
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
	#install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
	echo "add Microsoft key"
fi
if [ ! -f /etc/apt/sources.list.d/microsoft-edge-beta.list ]; then
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-beta.list
	echo "Added Microsoft Edge apt Source"
fi
if [ ! -f /usr/share/keyrings/Floorp.gpg ]; then
	curl -fsSL https://ppa.ablaze.one/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
	echo "Added Floorp Key"
fi
if [ ! -f /etc/apt/sources.list.d/Floorp.list ]; then
	curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
	echo "Added Floorp apt Source"
fi
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
	curl -fsSl https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	echo "Added Docker keyring"
fi
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
	echo "Added Docker apt source"
fi
apt-get update
VIRTUALIZATION=$(lscpu | grep Virtualization)
APTINSTALLLIST="tmux python3 make gcc ripgrep unzip git xclip ubuntu-restricted-extras neovim qemu-system quickemu remmina remmina-plugin-rdp remmina-plugin-secret remmina-dev floorp microsoft-edge-stable nala python3-venv python3-pip google-chrome-stable code kitty docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin distrobox ffmpeg gimp obs-studio"
if [[ $VIRTUALIZATION =~ "VT-x" ]] || [[ $VIRTUALIZATION =~ "AMD-V" ]]; then
	APTINSTALLLIST+=" quickemu virtualbox"
	IFVIRTUALIZATION=true
fi
$(apt-get --quiet=0 install $APTINSTALLLIST -y >> /dev/tty)
if [ -f /etc/apt/sources.list.d/microsoft-edge.list ] && [ -f /etc/apt/sources.list.d/microsoft-edge-beta.list ]; then
	rm /etc/apt/sources.list.d/microsoft-edge-beta.list
	echo "Removed script added source microsoft-edge-beta.list after initial install completes as after install microsoft-edge.list is added"
fi
APTINSTALLED=$(apt list --installed)
if [[ ! $APTINSTALLED =~ "packages-microsoft.prod" ]]; then
	curl -sSL -O https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
	dpkg -i ./packages-microsoft-prod.deb
	echo "Microsoft ppa installed"
	rm ./packages-microsoft-prod.deb
fi
VERSION=$(curl https://go.dev/dl/?mode=json | jq -r '.[0].version')
if [[ ! $(go version) =~ $VERSION ]]; then
	VERSION+=".linux-amd64.tar.gz"
	$(wget https://go.dev/dl/$VERSION)
	$(rm -rf /usr/local/go && tar -C /usr/local -xzf $VERSION)
	echo "GOLANG installed"
	$(rm ./$VERSION)
fi

