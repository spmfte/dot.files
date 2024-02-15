" Core Settings 
set runtimepath+=~/.vim/bundle/
set statusline=%f\ %p%%\ %l:%c
set t_Co=256
let mapleader = " "
let g:tagbar_ctags_bin = '/opt/homebrew/opt/ctags/bin/ctags'
set termguicolors
set background=light
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
set laststatus=2
syntax on
set nocompatible              " Be iMproved, required
filetype off                  " Required
filetype plugin indent on    " Required

" Plugin Management with Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'mhinz/vim-startify'
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
Plugin 'NLKNguyen/papercolor-theme'
call vundle#end()
colorscheme papercolor

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
let g:airline_theme='murmur'


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
" Startify Configuration for Enhanced UI/UX
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_files_number = 20

" Define the structure and content of the Startify screen
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']              },
      \ { 'type': 'files',     'header': ['   Recently Used Files']   },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']             },
      \ { 'type': 'commands',  'header': ['   Quick Commands']        },
      \ ]

" Define bookmarks for quick access
let g:startify_bookmarks = [
      \ { 'i': '~/.vimrc' },
      \ { 'p': '~/projects' },
      \ { 't': '~/todo.txt' },
      \ ]

" Define custom commands for quick actions
let g:startify_commands = [
      \ { 'name': 'Update Plugins', 'cmd': 'PluginUpdate' },
      \ { 'name': 'Change Theme',   'cmd': 'Telescope themes' },
      \ ]

" Define custom header with ASCII art
let g:startify_custom_header = 'startify#center(startify#fortune#boxed())'

" Define custom footer with additional information or actions
let g:startify_custom_footer = ['   Vim not NeoVim, yo!']

" Define the function for the theme switcher using FZF for live grep
function! s:switch_theme()
  let themes = split(globpath('~/.vim/plugged', '*/colors/*.vim'), '\n')
  call fzf#run(fzf#wrap({
        \ 'source':  map(themes, 'fnamemodify(v:val, ":t:r")'),
        \ 'sink':    's:apply_theme',
        \ 'options': '--prompt="Select Theme> "',
        \ }))
endfunction

function! s:apply_theme(theme)
  execute 'colorscheme ' . a:theme
endfunction

command! -nargs=* -complete=customlist,s:switch_theme Telescope call s:switch_theme()

" Styling for Startify
highlight StartifyHeader ctermfg=grey cterm=bold
highlight StartifyFooter ctermfg=grey cterm=italic
highlight StartifyNumber ctermfg=red
highlight StartifyPath ctermfg=cyan cterm=italic
highlight StartifySlash ctermfg=green cterm=italic
highlight StartifyFile ctermfg=yellow cterm=bold
highlight StartifyBracket ctermfg=darkgrey

" Borders for Startify (using ANSI escape codes, customize as needed)
let g:startify_custom_header = startify#center(map([
      \ '╭────────────────────────────────────────────────────────────────╮',
      \ '│                              Welcome                           │',
      \ '│░▀█▀▒██▀░▀▄▀░▀█▀░░▒█▀▒▄▀▄░█▄░█░▄▀▀░▀▄▀░▒█▒░█▄▄░█▒█░▒█▒▒░░█▀░█▀█░│',
      \ '│              ▌║█║▌│║▌│║▌║▌█║Vim User ▌│║▌║▌│║║▌█║▌║            │',   
      \ '│░▀█▀▒██▀░▀▄▀░▀█▀░░▒█▀▒▄▀▄░█▄░█░▄▀▀░▀▄▀░▒█▒░█▄▄░█▒█░▒█▒▒░░█▀░█▀█░│',
      \ '│                                                                │',   
      \ '╰────────────────────────────────────────────────────────────────╯'
      \ ], '"   " . v:val'))

" Open Startify at Vim startup if no files were specified
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | Startify | endif
