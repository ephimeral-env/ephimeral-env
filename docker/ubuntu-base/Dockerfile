#TODO: this seems to be working:
# https://github.com/fennerm/arch-i3-novnc-docker/blob/master/Dockerfile

#https://askubuntu.com/questions/969810/ubuntu-on-windows-10-docker-vs-wsl
# According to this article, it is not recommened to run a general purpose system on docker.
# Nevertheless there are some big advantages, like having a docker file that exactly describes how to setup the environment.

FROM ubuntu:20.04

# Disable questions from some packages during installation
ENV DEBIAN_FRONTEND="noninteractive" 

# Upgrade and install essential packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \ 
        git \
        curl \
        wget \
        iproute2 \
        openssh-server \
        sudo \
        # supervisor \
        software-properties-common

# Install python 3.8
# Do not install packages via pip, always create a venv first
RUN apt-get install -y python3.8 && \
    apt-get install -y python3.8-distutils && \
    apt-get install -y python3.8-venv

# Authorize SSH Host
RUN mkdir -p /root/.ssh && \
    chmod 0700 /root/.ssh && \
    ssh-keyscan github.com > /root/.ssh/known_hosts
COPY id_rsa /root/.ssh/id_rsa
COPY id_rsa.pub /root/.ssh/id_rsa.pub
RUN chmod 600 /root/.ssh/id_rsa && \
    chmod 600 /root/.ssh/id_rsa.pub

# Config git
RUN git config --global user.email "blascoburguillos@gmail.com" && \
    git config --global user.name "blasco"

# Dotfiles
# ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN git clone git@github.com:blasco/dotfiles.git ~/dotfiles && \
    cd ~/dotfiles && \
    git submodule update --init --recursive

# # TODO: I cannot get snap to work in docker...
# # Snap
# RUN apt-get install -y snapd squashfuse fuse
# RUN systemctl enable snapd

# Vim
RUN apt-get install -y vim vim-gtk3 && \
    rm -rf ~/.vim && \
    ln -s ~/dotfiles/vim ~/.vim && \
    # Install vim plugins \
    vim +PlugInstall +qall && \
    touch ~/dotfiles/vim/.vim_initialized

# Nvim
# TODO: download from gitrep and add symlink to usr/bin
RUN mkdir -p ~/programs/neovim && \
    cd ~/programs/neovim && \
    wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.tar.gz && \
    tar xzvf nvim-linux64.tar.gz && \
    ln -s ~/programs/neovim/nvim-linux64/bin /usr/bin/ && \
    rm nvim-linux64.tar.gz && \
    # Configure \
    mkdir ~/.config && \
    ln -s ~/dotfiles/vim  ~/.config/nvim && \
    # Fix white borders in gtk-3.0 \
    # ln -s ~/dotfiles/vim/gtk.css ~/.config/gtk-3.0/ && \
    # Add an entry on dmenu for neovim \
    ln -s ~/dotfiles/vim/nvim.desktop /usr/share/applications/

# i3
RUN add-apt-repository ppa:regolith-linux/release && \
    apt-get update && \
    apt-get install -y i3-gaps i3status && \
    ln -s ~/dotfiles/i3/i3status.conf ~/.i3status.conf && \
    ln -s ~/dotfiles/i3/ ~/.i3
    # Start i3 from docker with supervisord \
    # ln -s ~/dotfiles/i3/supervisord.conf /etc/supervisord.conf

# Cipboard manager
RUN cd /usr/bin && \
    wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip && \
    chmod a+x greenclip

# feh for background image
RUN apt-get install -y feh

# Compton is used for transparency in i3
RUN apt-get install -y compton compton-conf && \
    ln -s ~/dotfiles/i3/compton.conf /etc/xdg/compton.conf

# RXVT terminal
RUN apt-get install -y rxvt-unicode-256color x11-xserver-utils  && \
    ln -s ~/dotfiles/X11/Xresources ~/.Xresources && \
    git clone https://github.com/simmel/urxvt-resize-font ~/urxvt-resize-font && \
    mkdir -p ~/.urxvt/ext && \
    cp ~/urxvt-resize-font/resize-font ~/.urxvt/ext/ && \
    rm -rf ~/urxvt-resize-font

# ZSH shell
RUN apt-get install -y zsh && \
    cd ~/dotfiles/zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    rm -f ~/.zshrc && \
    ln -s ~/dotfiles/zsh/zshrc ~/.zshrc && \
    # Oh-my-zsh plugins
    git clone https://github.com/lukechilds/zsh-better-npm-completion ~/.oh-my-zsh/custom/plugins/zsh-better-npm-completion

# Inconsolata Nerd Font, used by Xresources and vim config files
RUN cp -r ~/dotfiles/fonts/inconsolata /usr/local/share/fonts/
 
# Autojump
RUN apt-get install -y autojump

# FZF for fuzzy command search
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

# Node Version Manager
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
SHELL ["/bin/zsh", "-c"]
RUN source ~/.zshrc && nvm install 16.16.0 && \
    nvm alias default node

# Google Chrome
# Web browser not properly working on docker, my current best approach is to open the port and connect to it
# https://askubuntu.com/questions/510056/how-to-install-google-chrome
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
#      echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | sudo tee /etc/apt/sources.list.d/google-chrome.list  && \
#     sudo apt-get update -y && \
#     sudo apt-get install -y google-chrome-stable
