" 1. Core Settings
set runtimepath+=~/.vim/bundle/
let mapleader = " "
let g:tagbar_ctags_bin = '/opt/homebrew/opt/ctags/bin/ctags'
set termguicolors
set t_Co=256
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
set nocompatible
set lazyredraw
if has('termguicolors')
 set termguicolors
endif
" load polygot before the plugin
let g:polyglot_disabled = ['autoindent']

" 2. Plugin Management with Vundle
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
filetype off
filetype plugin on
filetype plugin indent on

" 3. Key Mappings for Enhanced Productivity
let g:goyo_width = '100%'
let g:goyo_height = '100%'
noremap <C-c> :%y+<CR>
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
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :RG<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :Helptags<CR>
nnoremap <C-s> :w<CR>
nnoremap <C-q> :bd<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
:set nolist
nnoremap <leader>1 :split<CR>:NERDTreeExplore<CR>

" 4. Vim Airline Configuration
let g:airline#extensions#tabline#enabled = 0
let g:airline#extensions#tagbar#enabled = 1
let g:airline_theme='murmur'

" 5. Syntax Highlighting and Filetype Configuration
syntax enable

" 6. COC Configuration and Mappings
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)
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

" 7. Startify Configuration
let g:startify_session_dir = '~/.vim/sessions'
let g:startify_files_number = 20

" Merge MRU sections or clearly define their purpose
let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions'] },
      \ { 'type': 'files',     'header': ['   Most Recently Used Files'] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks'] },
      \ { 'type': 'commands',  'header': ['   Quick Commands'] },
      \ ]

" Define commands with clear names and actions
let g:startify_commands = [
      \ { 'name': 'Update Plugins (U)', 'cmd': 'PluginUpdate' },
      \ { 'name': 'Change Theme (cs)', 'cmd': 'call ChooseColorScheme()' },
      \ { 'name': 'Toggle Background (tb)', 'cmd': 'call ToggleBackground()' },
      \ ]

" Define bookmarks for quick access
let g:startify_bookmarks = [
      \ { 'i': '~/.vimrc' },
      \ { 'z': '~/.zshrc' },
      \ { 'p': '~/portfolio/' },
      \ { 't': '~/.config/' },
      \ ]

" Customize header
function! EnhancedStartifyHeader()
    let l:asciiArt = system('figlet -f whimsy  "Kora Vim"')
    let l:lines = split(l:asciiArt, "\n")
    let l:maxWidth = max(map(copy(l:lines), 'strdisplaywidth(v:val)'))
    let l:borderTop = '╔' . repeat('═', l:maxWidth + 2) . '╗'
    let l:borderBottom = '╚' . repeat('═', l:maxWidth + 2) . '╝'
    let l:lines = map(l:lines, '"║ " . v:val . " ║"')
    let l:header = [l:borderTop] + l:lines + [l:borderBottom]
    return startify#center(l:header)
endfunction
let g:startify_custom_header = EnhancedStartifyHeader()

" Customize footer
let g:startify_custom_footer = ['   Vim not NeoVim, yo!']

" Ensure 'commands' display their names directly on Startify
" If they're still showing as [cmd], verify Startify's latest documentation or GitHub issues for potential updates or bugs related to command rendering.

" 8. Additional Functions and Commands

" Function to choose a color scheme interactively
function! ChooseColorScheme()
    let schemes = split(globpath(&rtp, "colors/*.vim"), "\n")
    let schemeNames = map(schemes, 'fnamemodify(v:val, ":t:r")')
    echo "Select a color scheme:"
    let selections = map(copy(schemeNames), '"[" . (v:key + 1) . "] " . v:val')
    let selection = inputlist(insert(selections, "Type number and <Enter> or click with the mouse (q or empty cancels):"))
    if selection >= 1 && selection <= len(schemeNames)
        let chosenScheme = schemeNames[selection - 1]
        execute 'colorscheme ' . chosenScheme
    else
        echo "Invalid selection or operation cancelled."
    endif
endfunction

" Function to toggle the background setting
function! ToggleBackground()
    if &background == 'dark'
        set background=light
    else
        set background=dark
    endif
endfunction
nnoremap <F5> :call ToggleBackground()<CR>

" 9. Auto Commands
autocmd BufWritePost $MYVIMRC source $MYVIMRC

" 10. Color and Theme Settings
" Uncomment this if you want to use a specific colorscheme
" colorscheme papercolor

" 11. FZF Default Command Configuration
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow -g "!.git/*"'

" 12. Styling for Startify
highlight StartifyHeader ctermfg=grey cterm=bold
highlight StartifyFooter ctermfg=grey cterm=italic
highlight StartifyNumber ctermfg=red
highlight StartifyPath ctermfg=cyan cterm=italic
highlight StartifySlash ctermfg=green cterm=italic
highlight StartifyFile ctermfg=yellow cterm=bold
highlight StartifyBracket ctermfg=darkgrey
highlight StartifySectionHeader guifg=#FFD700 guibg=#008080 gui=bold
