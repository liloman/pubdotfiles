
My dotfiles. 

Work in progress to make vim working with lua + awesome (awful progress ... :S )


INSTALL

================

cd ; mkdir dotfiles_old ; mv .bashrc .inputrc .Xresources .Xdefaults .Xmodmap .vimperatorrc .tmux.conf .vimrc .vim dotfiles_old

git clone https://github.com/liloman/dotfiles.git 

ln -s dotfiles/bash/bashrc .bashrc
ln -s dotfiles/bash/inputrc .inputrc
ln -s dotfiles/bash/Xresources .Xresources
ln -s dotfiles/bash/Xdefaults .Xdefaults
ln -s dotfiles/bash/Xmodmap .Xmodmap


ln -s dotfiles/vimperator/vimperatorrc .vimperatorrc

ln -s dotfiles/tmux/tmux.conf .tmux.conf

ln -s dotfiles/vim/vimrc .vimrc

ln -s dotfiles/vim .vim

cd dotfiles

git submodule init

git submodule update --remote --merge
