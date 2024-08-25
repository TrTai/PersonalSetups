#!/bin/bash
#sed -i 's/WaylandEnable=false/WaylandEnable=true/g' /etc/gdm3/custom.conf
IFVIRTUALIZATION=false
sudo apt update
sudo add-apt-repository ppa:neovim-ppa/unstable -y
sudo add-apt-repository ppa:flexiondotorg/quickemu -y
if [ ! -f /usr/share/keyrings/microsoft.gpg ]; then
	curl https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
	#install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
	echo "add Microsoft key"
fi
if [ ! -f /etc/apt/sources.list.d/microsoft-edge-beta.list ]; then
	echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee -a /etc/apt/sources.list.d/microsoft-edge-beta.list > /dev/null
	echo "Added Microsoft Edge apt Source"
fi
if [ ! -f /usr/share/keyrings/Floorp.gpg ]; then
	curl -fsSL https://ppa.ablaze.one/KEY.gpg | sudo gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
	echo "Added Floorp Key"
fi
if [ ! -f /etc/apt/sources.list.d/Floorp.list ]; then
	sudo curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
	echo "Added Floorp apt Source"
fi
if [ ! -f /etc/apt/keyrings/docker.asc ]; then
	sudo curl -fsSl https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	echo "Added Docker keyring"
fi
if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
	sudo echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	echo "Added Docker apt source"
fi
sudo apt-get update
VIRTUALIZATION=$(lscpu | grep Virtualization)
APTINSTALLLIST="tmux python3 make gcc ripgrep unzip git xclip ubuntu-restricted-extras neovim remmina remmina-plugin-rdp remmina-plugin-secret remmina-dev chromium-browser floorp microsoft-edge-stable google-chrome-stable nala python3-venv python3-pip python3-pynvim code kitty docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin distrobox ffmpeg gimp obs-studio audacity handbrake vlc wireshark tshark"
if [[ $VIRTUALIZATION =~ "VT-x" ]] || [[ $VIRTUALIZATION =~ "AMD-V" ]]; then
	APTINSTALLLIST+=" qemu-system quickemu virtualbox"
	IFVIRTUALIZATION=true
fi
$(sudo apt-get --quiet=0 install $APTINSTALLLIST -y >> /dev/tty)
if [ -f /etc/apt/sources.list.d/microsoft-edge.list ] && [ -f /etc/apt/sources.list.d/microsoft-edge-beta.list ]; then
	sudo rm /etc/apt/sources.list.d/microsoft-edge-beta.list
	echo "Removed script added source microsoft-edge-beta.list after initial install completes as after install microsoft-edge.list is added"
fi
APTINSTALLED=$(apt list --installed)
if [[ ! $APTINSTALLED =~ "packages-microsoft.prod" ]]; then
	curl -sSL -O https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb
	sudo dpkg -i ./packages-microsoft-prod.deb
	echo "Microsoft ppa installed"
	rm ./packages-microsoft-prod.deb
fi
VERSION=$(curl https://go.dev/dl/?mode=json | jq -r '.[0].version')
if [[ ! $(go version) =~ $VERSION ]]; then
	VERSION+=".linux-amd64.tar.gz"
	$(wget https://go.dev/dl/$VERSION)
	$(sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf $VERSION)
	echo "GOLANG installed"
	$(rm ./$VERSION)
fi

#!/bin/bash
if [[ ! $PATH =~ "/usr/local/go/bin:" ]]; then
	echo 'export PATH="$PATH":/usr/local/go/bin:' >> ~/.bashrc
	export $PATH="$PATH":/usr/local/go/bin:
	echo "GOLANG added to PATH"
fi
if ! rustup --version ;then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
if [[ ! $(apt list --installed | grep xpipe) =~ "xpipe" ]];then
	bash <(curl -sL https://github.com/xpipe-io/xpipe/raw/master/get-xpipe.sh)
fi
git clone https://github.com/TrTai/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
mkdir ~/.config/tmux
echo -e "set -g mouse\nset-windows-option -g mode-keys vi\nset-option -g focus-events on\nset-option -sg escape-time 10" >> ~/.config/tmux/tmux.conf

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
flatpak install flathub md.obsidian.Obsidian com.jgraph.drawio.desktop -y
curl -f https://zed.dev/install.sh | sh
echo 'export PATH=$PATH:$HOME/.local/bin:' >> ~/.bashrc
nvm install 20
go get -u github.com/posener/complete/v2/gocomplete
COMP_INSTALL=1 gocomplete
