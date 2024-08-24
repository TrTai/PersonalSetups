#!/bin/bash
VERSION=$(curl https://go.dev/dl/?mode=json | jq -r '.[0].version')
VERSION+=".linux-amd64.tar.gz"
$(wget https://go.dev/dl/$VERSION)
$(rm -rf /usr/local/go && tar -C /usr/local -xzf $VERSION)
#echo "GOLANG installed"
echo 'export PATH="$PATH":/usr/local/go/bin' >> ~/.bashrc
#echo "GOLANG added to PATH"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
bash <(curl -sL https://github.com/xpipe-io/xpipe/raw/master/get-xpipe.sh)
wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py
python3 -m pip install --user --upgrade pynvim
git clone https://github.com/TrTai/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
