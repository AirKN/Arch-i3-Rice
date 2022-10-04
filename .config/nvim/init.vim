let g:gruvbox_termcolors=16
set bg=dark
let g:gruvbox_italic=1
colo gruvbox
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE


set hlsearch
set incsearch

set clipboard=unnamedplus
set tabstop=4
set softtabstop=4
set shiftwidth=4

set expandtab
set autoindent
set fileformat=unix

syntax on
set encoding=utf-8
set number relativenumber

set wildmode=longest,list,full


set splitbelow splitright
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <C-s> :%s//g<Left><Left>
nnoremap <silent> <C-t> :tabnew<CR>

autocmd BufWritePre * %s/\s\+$//e



