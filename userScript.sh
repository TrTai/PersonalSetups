#!/bin/bash
if [[ $PATH =~ "/usr/local/go/bin:" ]]; then
	echo 'export PATH="$PATH":/usr/local/go/bin:' >> ~/.bashrc
	echo "GOLANG added to PATH"
fi
if ! rustup --version ;then
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi
if [[ ! $(apt list --installed | grep xpipe) =~ "xpipe" ]];then
	bash <(curl -sL https://github.com/xpipe-io/xpipe/raw/master/get-xpipe.sh)
fi
#python3 -m pip install --user --upgrade pynvim
pip install pynvim
git clone https://github.com/TrTai/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

