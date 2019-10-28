#!/bin/bash

install_brew(){
	echo "安装Homebrew包管理器中..."
	if [ -z "`which brew`" ]; then
		/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
		[ $? -ne 0 ] && echo "请检查网络问题！" && exit
	else
		echo "检测到Homebrew已安装！"
		return
	fi
	echo "更换Homebrew为国内源"
	cd "$(brew --repo)"
	git remote set-url origin https://mirrors.ustc.edu.cn/brew.git
	cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
	git remote set-url origin https://mirrors.ustc.edu.cn/homebrew-core.git
	echo 'export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles' >> ~/.bash_profile
	source ~/.bash_profile
	brew install zsh-syntax-highlighting coreutils screenfetch
	sleep 1
	echo "安装完成！"
}

check_xcode() {
	git --help &> /dev/null || xcode-select --install 
}

install_zsh() {
	echo "安装Oh-my-zsh中..."
	if [ "$SHELL" != "/bin/zsh" ] || [ ! -d ~/.oh-my-zsh ]; then
		rm -rf ~/.oh-my-zsh
		curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
		[ $? -ne 0 ] && echo "请检查网络问题！" && exit
	else
		echo "检测到Oh-my-zsh已安装！"
		return
	fi
	sleep 1
	echo "安装完成！"
}

config_zshrc() {
	[ ! -d /usr/local/opt/coreutils/ ] && brew install coreutils
	[ ! -d /usr/local/share/zsh-syntax-highlighting ] && brew install zsh-syntax-highlighting
	echo "修改zshrc环境变量文件..."
	cat > ~/.zshrc <<-\EOF
	export ZSH=~/.oh-my-zsh
	ZSH_THEME="agnoster"
	plugins=(git last-working-dir)
	source $ZSH/oh-my-zsh.sh
	# 设置coreutils工具
	export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
	export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
	# 修改Homebrew Bottles源
	export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
	# zsh高亮插件
	source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	# 添加coreutils的ls主题solarized
	eval `dircolors ~/.dircolors`
	alias ls="ls --color=auto"
	# 解决screenfetch显示bug，替换readlink为coreutils
	alias readlink=greadlink
	# http proxy
	# http_proxy_ip="127.0.0.1"
	# http_proxy_port="1087"
	# if (echo -e "\n"|telnet ${http_proxy_ip} ${http_proxy_port} | grep "Connected") &> /dev/null; then
	# 	export http_proxy=http://${http_proxy_ip}:${http_proxy_port}
	#	export https_proxy=https://${http_proxy_ip}:${http_proxy_port}
	# else 
	#	export http_proxy=""
	#	export https_proxy=""
	# fi
	EOF
	sleep 1
	echo "修改完成！"
}

config_vim() {
	echo "设置vim的solarized主题..."
	if [ ! -f ~/.vim/colors/solarized.vim ]; then
		rm -rf ~/vim-colors-solarized
		git clone https://github.com/altercation/vim-colors-solarized.git ~/vim-colors-solarized
		[ $? -ne 0 ] && echo "请检查网络问题！" && exit
		#sudo cp -rf ~/vim-colors-solarized/* /usr/share/vim/vim*/
		[ ! -d ~/.vim ] && mkdir -p ~/.vim
		cp -rf ~/vim-colors-solarized/* ~/.vim
		echo "syntax enable\nset background=dark\ncolorscheme solarized" > ~/.vimrc
		rm -rf ~/vim-colors-solarized
	else
		echo "检测到vim主题已设置！"
		return
	fi
	sleep 1
	echo "设置完成！"
}

config_ls() {
	echo "设置ls的solarized主题..."
	if [ ! -f ~/.dircolors ]; then
		rm -rf ~/dircolors-solarized
		git clone https://github.com/seebi/dircolors-solarized.git ~/dircolors-solarized
		[ $? -ne 0 ] && echo "请检查网络问题！" && exit
		cp -rf ~/dircolors-solarized/dircolors.256dark ~/.dircolors
		rm -rf ~/dircolors-solarized
	else
		echo "检测到ls主题已设置！"
		return
	fi
	sleep 1
	echo "设置完成！"
}

terminal_solarized() {
	echo "设置终端solarized主题..."
	rm -rf ~/Mac-Terminal
	git clone https://github.com/monlor/Mac-Terminal.git ~/Mac-Terminal
	[ $? -ne 0 ] && echo "请检查网络问题！" && exit
	cp -rf ~/Mac-Terminal/Meslo\ LG\ L\ DZ\ Regular\ for\ Powerline.ttf /Library/Fonts
	echo "即将打开新的solarized主题终端，请设置其为默认主题"
	sleep 3
	/Applications/Utilities/Terminal.app/Contents/MacOS/Terminal ~/Mac-Terminal/Solarized\ Dark\ xterm-256color.terminal &
	sleep 2
	rm -rf ~/Mac-Terminal

}

main() {
	check_xcode
	install_zsh
	install_brew
	config_ls
	config_vim
	config_zshrc
	terminal_solarized
}

main
