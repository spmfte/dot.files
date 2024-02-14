" Core Settings 
set statusline=%f\ %p%%\ %l:%c
let mapleader = " "
let g:tagbar_ctags_bin = '/opt/homebrew/opt/ctags/bin/ctags'
set termguicolors
set background=light
colorscheme zellner 
set t_Co=8
set history=10000
set number
set cursorline
set cursorcolumn
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set mouse=a
set incsearch
set hlsearch
set clipboard=unnamed
syntax on




" Plugin Management with Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'
Plugin 'preservim/nerdtree'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'junegunn/fzf.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Plugin 'sheerun/vim-polyglot'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'itchyny/lightline.vim'
Plugin 'voldikss/vim-floaterm'
Plugin 'mhinz/vim-signify'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'easymotion/vim-easymotion'
Plugin 'ryanoasis/vim-devicons'
Plugin 'majutsushi/tagbar'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-surround'
Plugin 'junegunn/gv.vim'
Plugin 'w0rp/ale'
Plugin 'kkoomen/vim-doge'
call vundle#end()





" Key Mappings for Enhanced Productivity
map <C-n> :NERDTreeToggle<CR>
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
nnoremap <leader>z :Goyo<CR>
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!
let g:coc_global_extensions = ['coc-json', 'coc-css', 'coc-html', 'coc-python', 'coc-snippets']
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader><leader> :<Plug>(easymotion-prefix)<CR>
nnoremap <C-i> :FloatermToggle<CR>




" FZF Integration for File Searching
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :RG<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>




" Advanced Tweaks for Efficiency
" Fast saving with Ctrl-s
nnoremap <C-s> :w<CR>
" Close current buffer without closing Vim
nnoremap <C-q> :bd<CR>
" Split navigation shortcuts
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
:set nolist
nnoremap <leader>1 :split<CR>:NERDTreeExplore<CR>




" Vim Airline: Enhanced status bar
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tagbar#enabled = 1
let g:airline_theme='bubblegum'




" Improve startup time
set lazyredraw




" Syntax highlighting enhancements
let g:polyglot_disabled = ['autoindent']
syntax enable




" COC Enhancements


" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


" Use `K` to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocAction('doHover')
  else
    execute '!' . &keywordprg . ' ' . expand('<cword>')
  endif
endfunction




" Make Vim more resilient: Auto-reload vimrc file on changes
autocmd BufWritePost $MYVIMRC source $MYVIMRC



" Ensure backward compatibility with older Vim versions
if v:version < 800

  " Custom tweaks for older Vim versions
endif



" Aesthetic Enhancements

" Enable true color support
if has('termguicolors')
  set termguicolors
endif


let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow -g "!.git/*"'

