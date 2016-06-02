
#My dotfiles. 
============

Managed with stow (wonderful symlink farm).

##INSTALL


```bash
git clone https://github.com/liloman/dotfiles.git 
cd dotfiles 
./install.sh -d  (for desktop use)
./install.sh -s  (for server use)
```

## TODO
- [x] Make a repo for my dir stack itself [dirStack](https://github.com/liloman/dirStack)
- [x] clean bash script for firefox cache/ (cleanFirefox)
- [x] include completions dir for [generate-autocompletion](https://github.com/liloman/generate-autocompletion)
- [x] Rework install.sh 
- [x] bash surround and i/a objects for bash (see ~/.inputrc) 
- [x] bash <-> readline pseudo async communication  (see ctrl-g functions in ~/.inputrc) 
- [ ] Fork needed submodules and add them to install.sh with function
- [ ] libnotify saves notifies while not X running
- [ ] Better color handling and reporting for .bash_functions (needs more time)
- [ ] Ansible && systemd work


