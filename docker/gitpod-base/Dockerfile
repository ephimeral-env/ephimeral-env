FROM gitpod/workspace-full-vnc 

# Disable questions from some packages during installation
ENV DEBIAN_FRONTEND="noninteractive" 

# Upgrade and install essential packages

RUN sudo apt-get update && \
    sudo apt-get upgrade -y && \
    sudo apt-get install -y \ 
        git \
        curl \
        wget \
        iproute2 \
        openssh-server \
        sudo \
        # supervisor \
        software-properties-common

USER gitpod

RUN git clone git@github.com:blasco/dotfiles.git ~/dotfiles && \
    cd ~/dotfiles && \
    git submodule update --init --recursive

# Vim
RUN sudo apt-get install -y vim vim-gtk3 && \
    rm -rf ~/.vim && \
    ln -s ~/dotfiles/vim ~/.vim && \
    # Install vim plugins \
    vim +PlugInstall +qall && \
    touch ~/dotfiles/vim/.vim_initialized

# Nvim
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
RUN sudo add-apt-repository ppa:regolith-linux/release && \
    sudo apt-get update && \
    sudo apt-get install -y i3-gaps i3status && \
    ln -s ~/dotfiles/i3/i3status.conf ~/.i3status.conf && \
    ln -s ~/dotfiles/i3/ ~/.i3
    # Start i3 from docker with supervisord \
    # ln -s ~/dotfiles/i3/supervisord.conf /etc/supervisord.conf

# feh for background image
RUN sudo apt-get install -y feh

# RXVT terminal
RUN sudo apt-get install -y rxvt-unicode-256color x11-xserver-utils  && \
    ln -s ~/dotfiles/X11/Xresources ~/.Xresources && \
    git clone https://github.com/simmel/urxvt-resize-font ~/urxvt-resize-font && \
    mkdir -p ~/.urxvt/ext && \
    cp ~/urxvt-resize-font/resize-font ~/.urxvt/ext/ && \
    rm -rf ~/urxvt-resize-font

# ZSH shell
RUN sudo apt-get install -y zsh && \
    cd ~/dotfiles/zsh && \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended && \
    rm -f ~/.zshrc && \
    ln -s ~/dotfiles/zsh/zshrc ~/.zshrc && \
    # Oh-my-zsh plugins
    git clone https://github.com/lukechilds/zsh-better-npm-completion ~/.oh-my-zsh/custom/plugins/zsh-better-npm-completion

# Inconsolata Nerd Font, used by Xresources and vim config files
RUN cp -r ~/dotfiles/fonts/inconsolata /usr/local/share/fonts/
 
# Autojump
RUN sudo apt-get install -y autojump

# FZF for fuzzy command search
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install
