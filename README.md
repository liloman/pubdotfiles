
My dotfiles. 

Work in progress to make vim working with lua + awesome


INSTALL

================

cd ; mkdir dotfiles_old ; mv .bashrc .vimperatorrc .tmux.conf .vimrc .vim dotfiles_old

git clone https://github.com/liloman/dotfiles.git 

ln -s dotfiles/bash/bashrc .bashrc

ln -s dotfiles/vimperator/vimperatorrc .vimperatorrc

ln -s dotfiles/tmux/tmux.conf .tmux.conf

ln -s dotfiles/vim/vimrc .vimrc

ln -s dotfiles/vim .vim

cd dotfiles

git submodule init

git submodule update
