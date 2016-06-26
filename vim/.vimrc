" VIM configuration file
" Copyright © 2016 liloman
"
" This program is free software: you can redistribute it and/or modify
" it under the terms of the GNU General Public License as published by
" the Free Software Foundation, either version 3 of the License, or
" (at your option) any later version.
"
" This program is distributed in the hope that it will be useful,
" but WITHOUT ANY WARRANTY; without even the implied warranty of
" MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
" GNU General Public License for more details.
"
" You should have received a copy of the GNU General Public License
" along with this program.  If not, see <http://www.gnu.org/licenses/>.

""""""""""""""
"  Settings  "
""""""""""""""

set number
set columns=80
set colorcolumn=80

" this enables "visual" wrapping
set wrap
" set textwidth=80
" this turns off physical line wrapping (ie: automatic insertion of newlines)
set textwidth=0 wrapmargin=0

" enable per-directory .vimrc files 
set exrc        
" disable unsafe commands in local .vimrc files 
set secure      

" ================ Persistent Undo ==================
" " Keep undo history across sessions, by storing in file.
if has('persistent_undo')
    silent !mkdir ~/.vim/undodir > /dev/null 2>&1
    set undodir=~/.vim/undodir
    set undofile
endif

set laststatus=2

"change the buffer without saving it
set hidden

if !has('gui_running')
    set t_Co=256
endif

"set modelines for custom file settings
set modeline
"lines top/down to search for the mode
set modelines=5

set clipboard=unnamedplus

" ================ Folding ======================
set fdm=syntax
set fdc=4
set fdl=4

" ================ Indentation ======================
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=2
set expandtab
filetype plugin indent on
syntax on

"Space is the leader  :D
let mapleader=" "

""""""""""""""
"  Mappings  "
""""""""""""""

nmap <F3> :NERDTreeToggle<CR>
nmap <F4> :TagbarToggle<CR>
" nnoremap <F5> :GundoToggle<CR>
" Search whole word CWORD under cursor
nnoremap <F5> :let @/.='<'.expand("<CWORD>").'\>'<CR>n

"Execute current file with Bexec plugin
nmap <silent> <unique> <Leader>e :Bexec()<CR>
vmap <silent> <unique> <Leader>e :BexecVisual()<CR>

"To group with ease from the command line
cmap ;\ \(\)<Left><Left>

"Save with C-S
nmap <c-s> :update<CR>
vmap <c-s> <Esc><c-s>gv
imap <c-s> <Esc><c-s>
" Command Make will call make and then cwindow which
" opens a 3 line error window if any errors are found.
" If no errors, it closes any open cwindow.
:command -nargs=* Make make <args> | cwindow 3
nmap <Leader>m :Make<cr>

" nmap J Jx
nmap <Leader>t :tag 
"Toggle line numbers (for copying...)
nmap <Leader>n :set invnumber<CR> 

"Toggle highlight for searchs
let hlstate=0
nnoremap <Leader>s :if (hlstate == 0) \| nohlsearch \| else \| set hlsearch \| endif \| let hlstate=1-hlstate<cr>

" ================ Move between buffers ======================
nmap <Leader>l :bnext<CR>
nmap <Leader>h :bprevious<CR>
nmap <Leader>k :b#<CR>
nmap <Leader>j :blast<CR>
" Delete current buffer without delete window
nmap <leader>b :bn\|bd#<CR>

" ================ Undo / Paste ======================
"Undo en insert mode 
inoremap <silent> <C-W> <C-\><C-O>db
inoremap <silent> <C-U> <C-\><C-O>d0
"Paste what you've deleted in insert mode
inoremap <silent> <C-Y> <C-R>" 


"""""""""""""
"  Plugins  "
"""""""""""""
"Pathogen
call pathogen#infect() 
call pathogen#helptags()

" Enable built-in matchit plugin
runtime macros/matchit.vim
"Enable :Man to read manpages ... :)
runtime! ftplugin/man.vim


" to change the macro storage location use the following
let marvim_store='/home/charly/.vim/.macros'
let marvim_find_key = '<Leader>1' " busca macro Space+F2
let marvim_store_key = '<Leader>0'     " guardar macro Space+F3 
let marvim_register = 'c'       " change used register from 'q' to 'c'
let marvim_prefix = 1           " disable default syntax based prefix 

" Autofocus on tagbar
let g:tagbar_autofocus = 1

"gf search in local paths also
set path=.,include/,src/ ",** recursive:better --> :tag filename.c

"Bexec shows the stdout on below window
set splitbelow
"
" ================ Easymotion power ======================
let g:EasyMotion_smartcase=1
map <Leader><Leader>l <Plug>(easymotion-lineforward)
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><Leader>h <Plug>(easymotion-linebackward)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" ================ Ultimate snipper ======================
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsListSnippets="<tab><tab>"
"let g:snippets_dir = "~/.vim/ownsnippets/"

"Disable Lua inspect...
let g:loaded_luainspect = 1

" let g:lightline = {'colorscheme': 'wombat',}
"vim status lightline config
let g:lightline = {
      \ 'colorscheme': 'landscape',
      \ 'mode_map': { 'c': 'NORMAL' },
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'LightLineModified',
      \   'readonly': 'LightLineReadonly',
      \   'fugitive': 'LightLineFugitive',
      \   'filename': 'LightLineFilename',
      \   'fileformat': 'LightLineFileformat',
      \   'filetype': 'LightLineFiletype',
      \   'fileencoding': 'LightLineFileencoding',
      \   'mode': 'LightLineMode',
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

function! LightLineModified()
  return &ft =~ 'help\|vimfiler\|gundo' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightLineReadonly()
  return &ft !~? 'help\|vimfiler\|gundo' && &readonly ? '' : ''
endfunction

function! LightLineFilename()
  return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
endfunction

function! LightLineFugitive()
  "if &ft !~? 'vimfiler\|gundo' && exists("*fugitive#head")
    " let _ = fugitive#head()
  if &ft !~? 'vimfiler\|gundo' && exists("*GitBranchInfoString")
    let _ = GitBranchInfoString()
    return strlen(_) ? ''._ : ''
  endif
  return ''
endfunction

function! LightLineFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! LightLineFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! LightLineFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! LightLineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

" The message when there is no Git repository on the current dir
let g:git_branch_status_nogit=""
" This will show just the current head branch name
let g:git_branch_status_head_current=1
" Dont put anything around branch name
let g:git_branch_status_around=""
"No text 
let g:git_branch_status_text=""
let g:git_branch_status_ignore_remotes=1



colorscheme Monokai

"Change default "l" latex for vim surround (ysiwlgls)
let g:surround_108 = "\\\1environment:\1{\r}"


""""""""""""""
"  Autocmds  "
""""""""""""""

" Set zellnet for tex files. Not working properly :(
autocmd FileType tex colorscheme zellner | colo zellner

au BufRead,BufNewFile *.bats set filetype=sh

