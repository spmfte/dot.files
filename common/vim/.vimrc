set statusline=%f\ %p%%\ %l:%c
let mapleader = " "

" Set the vibe with a retro light theme
set termguicolors
set background=light " or light, depending on your preference
colorscheme elflord

" Force the use of 8-bit displays
set t_Co=8

" Max out history for that 'never forget' attitude
set history=10000

" Enable line numbers, because real programmers navigate by line
set number

" Highlight current line, standing out in the crowd
set cursorline

" Use spaces instead of tabs, because precision is key
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

" Enable mouse mode, but who uses a mouse anyway?
set mouse=a

" Make searching feel like a treasure hunt
set incsearch
set hlsearch

" Retro doesn't mean inefficient, enable syntax highlighting
syntax on

" Plugin time: Vundle for managing plugins, because manual is the alpha way
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Airline for that command-line bling
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'

" Zen Mode: Goyo and Limelight for distraction-free writing and coding
Plugin 'junegunn/goyo.vim'
Plugin 'junegunn/limelight.vim'

" NERDTree for exploring your dominions
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
Plugin 'easymotion/vim-easymotion'
Plugin 'ryanoasis/vim-devicons'
Plugin 'majutsushi/tagbar'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tpope/vim-rhubarb'
Plugin 'tpope/vim-surround'
Plugin 'junegunn/gv.vim'
Plugin 'w0rp/ale'
Plugin 'kkoomen/vim-doge'
Plugin 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Remove YouCompleteMe as coc.nvim is being used
" Plugin 'ycm-core/YouCompleteMe'

call vundle#end()

" Map NERDTree toggle to CTRL+n, because efficiency is key
map <C-n> :NERDTreeToggle<CR>

" Make Vim more challenging: disable arrow keys in normal mode
noremap <Up> <Nop
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>

" Zen Mode activation: Toggle Goyo for focused writing
nnoremap <leader>z :Goyo<CR>
" Limelight activation: Highlight the current paragraph
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Configure coc.nvim with vimscript
" For detailed coc.nvim settings, use :CocConfig and add settings in JSON format
let g:coc_global_extensions = ['coc-json', 'coc-css', 'coc-html', 'coc-python', 'coc-snippets']

" File explorer toggle
nnoremap <leader>e :NERDTreeToggle<CR>

" Tagbar toggle to view the structure of code
nnoremap <leader>t :TagbarToggle<CR>

" Terminal toggle
nnoremap <leader>f :FloatermToggle<CR>

" EasyMotion activation for quick navigation
nnoremap <leader><leader> :<Plug>(easymotion-prefix)<CR>

" Disable backups and swap files to make Vim a fortress of solitude
set nobackup
set nowritebackup
set noswapfile


