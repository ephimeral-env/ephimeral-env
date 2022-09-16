FROM archlinux:latest

# Run the image with:
# docker run -it -v C:\Users\blasc\projects\you-art\:/workspace -h "dev-env-youart" --privileged -p 8083:8083 -p 6080:6080 blascoburguillos/dev-env:arch-22.9.14
# After lanching the image run /start.sh and navigate with the browser to: 
# http://localhost:6080/vnc.html

ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache

# Disable questions from some packages during installation
ENV DEBIAN_FRONTEND="noninteractive" 

SHELL ["/bin/bash", "-c"]

# Upgrade and install essential packages
RUN pacman -Syu  --noconfirm
RUN pacman -Fy  --noconfirm
RUN pacman -S  --noconfirm \
        git \
        curl \
        wget \
        iproute2 \
        openssh \
        sudo \
        base-devel \
        dbus

# makepkg user and workdir
ARG user=dev
RUN useradd --system --create-home $user && \
    echo "$user ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers.d/$user
USER $user
WORKDIR /home/$user

# Install yay
RUN git clone https://aur.archlinux.org/yay.git && \
    cd yay && \
    makepkg -sri --needed --noconfirm && \
    cd && \
    # Clean up
    rm -rf .cache yay

# Python
RUN sudo pacman -S --noconfirm python

# # Authorize SSH Host
# RUN mkdir -p ~/.ssh && \
#     chmod 0700 ~/.ssh && \
#     ssh-keyscan github.com > ~/.ssh/known_hosts
# COPY id_rsa /home/$user/.ssh/id_rsa
# COPY id_rsa.pub /home/$user/.ssh/id_rsa.pub
# RUN sudo chmod a+r ~/.ssh/id_rsa && \
#     sudo chmod a+r ~/.ssh/id_rsa.pub

# Config git
RUN git config --global user.email "dev@devenv.com" && \
    git config --global user.name "dev"

# Dotfiles
RUN git clone https://github.com/blasco/dotfiles ~/dotfiles && \
    cd ~/dotfiles && \
    git submodule update --init --recursive

# Vim
RUN sudo pacman -S --noconfirm vim gvim && \
    rm -rf ~/.vim && \
    ln -s ~/dotfiles/vim ~/.vim && \
    # Install vim plugins \
    vim +PlugInstall +qall && \
    touch ~/dotfiles/vim/.vim_initialized

# Neovim
RUN mkdir -p ~/programs/neovim && \
    cd ~/programs/neovim && \
    wget https://github.com/neovim/neovim/releases/download/v0.7.2/nvim-linux64.tar.gz && \
    tar xzvf nvim-linux64.tar.gz && \
    sudo ln -s ~/programs/neovim/nvim-linux64/bin/nvim /usr/bin/nvim && \
    rm nvim-linux64.tar.gz && \
    # Configure \
    mkdir ~/.config && \
    ln -s ~/dotfiles/vim  ~/.config/nvim && \
    # Install vim plugins \
    nvim +PlugInstall +qall

# i3
RUN sudo pacman -S --noconfirm i3-gaps i3status && \
    ln -s ~/dotfiles/i3/i3status.conf ~/.i3status.conf && \
    ln -s ~/dotfiles/i3/ ~/.i3

# Cipboard manager
RUN cd /usr/bin && \
    sudo wget https://github.com/erebe/greenclip/releases/download/v4.2/greenclip && \
    sudo chmod a+x greenclip

# feh for background image
RUN sudo pacman -S --noconfirm feh

# Compton is used for transparency in i3
RUN sudo pacman -S --noconfirm compton && \
    sudo ln -s ~/dotfiles/i3/compton.conf /etc/xdg/compton.conf

# RXVT terminal
RUN sudo pacman -S --noconfirm rxvt-unicode xorg-xrdb   && \
    ln -s ~/dotfiles/X11/Xresources ~/.Xresources && \
    git clone https://github.com/simmel/urxvt-resize-font ~/urxvt-resize-font && \
    mkdir -p ~/.urxvt/ext && \
    cp ~/urxvt-resize-font/resize-font ~/.urxvt/ext/ && \
    rm -rf ~/urxvt-resize-font

# ZSH shell
RUN sudo pacman -S --noconfirm zsh && \
    cd ~/dotfiles/zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    rm -f ~/.zshrc && \
    ln -s ~/dotfiles/zsh/zshrc ~/.zshrc && \
    # Oh-my-zsh plugins
    git clone https://github.com/lukechilds/zsh-better-npm-completion ~/.oh-my-zsh/custom/plugins/zsh-better-npm-completion

# Inconsolata Nerd Font, used by Xresources and vim config files
RUN sudo cp -r ~/dotfiles/fonts/inconsolata /usr/local/share/fonts/
 
# Autojump
RUN yay -S --noconfirm autojump

# FZF for fuzzy command search
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

# Node Version Manager
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
SHELL ["/bin/zsh", "-c"]
RUN source ~/.zshrc && nvm install 16.16.0 && \
    nvm alias default node

# Install packages
RUN sudo pacman -S --noconfirm \
        net-tools \
        inetutils \
        python-numpy \
        supervisor \
        x11vnc \
        xorg-server \
        xorg-apps \
        xorg-server-xvfb

# Set up noVNC
WORKDIR /opt/
RUN sudo git clone https://github.com/novnc/noVNC

# TODO: is this needed?
# WORKDIR /var/log/supervisor/

# Prepare X11, x11vnc, i3 and noVNC from supervisor
COPY supervisord.conf /etc/supervisord.conf
COPY start.sh /
RUN sudo chmod a+x /start.sh

# tmux: terminal multiplexser
RUN sudo pacman -S --noconfirm tmux

# ranger: terminal directory explorer
RUN sudo pacman -S --noconfirm ranger

# Be sure that the noVNC port is exposed
EXPOSE 8083
EXPOSE 6080

# Google Chrome
# Web browser not properly working on docker, my current best approach is to open the port and connect to it
# RUN yay -S --noconfirm google-chrome
