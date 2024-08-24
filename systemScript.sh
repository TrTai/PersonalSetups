#!/bin/bash
sed -i 's/WaylandEnable=false/WaylandEnable=true/g' /etc/gdm3/custom.conf
IFVIRTUALIZATION=false
add-apt-repository ppa:neovim-ppa/unstable -y
add-apt-repository ppa:flexiondotorg/quickemu -y
if [ ! -f /usr/share/keyrings/microsoft.gpg ]; then
	curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
	#install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
	echo "add Microsoft key"
fi
if [ ! -f /etc/apt/sources.list.d/microsoft-edge-beta.list ]; then
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-beta.list
	echo "Added Microsoft Edge Source"
fi
if [ ! -f /usr/share/keyrings/Floorp.gpg ]; then
	curl -fsSL https://ppa.ablaze.one/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
	echo "Added Floorp Key"
fi
if [ ! -f /etc/apt/sources.list.d/Floorp.list ]; then
	curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
	echo "Added Floorp Source"
fi
apt-get update
VIRTUALIZATION=$(lscpu | grep Virtualization)
APTINSTALLLIST="tmux python3 make gcc ripgrep unzip git xclip neovim cosmic-session remmina remmina-plugin-rdp remmina-plugin-secret remmina-dev floorp microsoft-edge-stable nala"
if [[ $VIRTUALIZATION =~ "VT-x" ]] || [[ $VIRTUALIZATION =~ "AMD-V" ]]; then
	APTINSTALLLIST+=" quickemu virtualbox"
	IFVIRTUALIZATION=true
fi
$(apt-get install $APTINSTALLLIST -y >> ./systemScript-apt-log.log)
APTINSTALLED=$(apt list --installed)
if [[ ! $APTINSTALLED =~ "google-chrome" ]]; then
	apt install ./google-chrome-stable_current_amd64.deb
	echo "Chrome installed"
fi
if [[ ! $APTINSTALLED =~ "packages-microsoft.prod" ]]; then
	curl -sSL -O https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
	dpkg -i ./packages-microsoft-prod.deb
	echo "Microsoft ppa installed"
fi
VERSION=$(curl https://go.dev/dl/?mode=json | jq -r '.[0].version')
if [[ ! $(go version) =~ $VERSION ]]; then
	VERSION+=".linux-amd64.tar.gz"
	$(wget https://go.dev/dl/$VERSION)
	$(rm -rf /usr/local/go && tar -C /usr/local -xzf $VERSION)
	echo "GOLANG installed"
fi

