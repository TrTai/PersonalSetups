#!/bin/bash
sed -i 's/WaylandEnable=false/WaylandEnable=true/g' /etc/gdm3/custom.conf
IFVIRTUALIZATION=false
add-apt-repository ppa:neovim-ppa/unstable -y
add-apt-repository ppa:flexiondotorg/quickemu -y
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /usr/share/keyrings/microsoft.gpg
#install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-beta.list
curl -fsSL https://ppa.ablaze.one/KEY.gpg | gpg --dearmor -o /usr/share/keyrings/Floorp.gpg
curl -sS --compressed -o /etc/apt/sources.list.d/Floorp.list 'https://ppa.ablaze.one/Floorp.list'
curl -sSL -O https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb
dpkg -i ./packages-microsoft-prod.deb
apt update
apt-get install nala -y
VIRTUALIZATION=$(lscpu | grep Virtualization)
APTINSTALLLIST="tmux python3 make gcc ripgrep unzip git xclip neovim cosmic-session remmina remmina-plugin-rdp remmina-plugin-secret remmina-dev floorp microsoft-edge-stable"
if [[ $VIRTUALIZATION =~ "VT-x" ]] || [[ $VIRTUALIZATION =~ "AMD-V" ]]; then
	APTINSTALLLIST+=" quickemu virtualbox"
	IFVIRTUALIZATION=true
fi
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt install ./google-chrome-stable_current_amd64.deb
#echo "Chrome installed"
nala fetch --auto --fetches 5
nala update
$(nala install $APTINSTALLLIST -y)
bash <(curl -sL https://github.com/xpipe-io/xpipe/raw/master/get-xpipe.sh)
VERSION=$(curl https://go.dev/dl/?mode=json | jq -r '.[0].version')
VERSION+=".linux-amd64.tar.gz"
$(wget https://go.dev/dl/$VERSION)
$(rm -rf /usr/local/go && tar -C /usr/local -xzf $VERSION)
#echo "GOLANG installed"

