#!/bin/bash
echo 'export PATH="$PATH":/usr/local/go/bin' >> ~/.bashrc
#echo "GOLANG added to PATH"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
bash <(curl -sL https://github.com/xpipe-io/xpipe/raw/master/get-xpipe.sh)
wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py
python3 -m pip install --user --upgrade pynvim
git clone https://github.com/TrTai/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
