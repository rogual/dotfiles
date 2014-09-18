
" Stop Vim from sucking ass
set nocompatible
set nobackup
set noswapfile
set hidden
set noshellslash
set noshowcmd
set vb

if has('nvim')
    " These should point to Python envs with neovim module installed
    let g:python_host_prog = 'python2.7'
    let g:python2_host_prog = 'python2.7'
    let g:python3_host_prog = 'python3.5'

    " Detect VEs
    function! VE()
        let cwd = getcwd()
        let ve = cwd . "/ve"
        let act = ve . "/bin/activate"
        if filereadable(act)
            let g:python_host_prog = ve . "/bin/python2"
            let g:python3_host_prog = ve . "/bin/python3"
            echom "Switched to VE at " . ve
        else
            echom "No VE found at " . ve
        endif
    endfunction
    nmap <leader>e :call VE()<CR>

    autocmd CompleteDone * pclose
endif

runtime! macros/matchit.vim
map Y y$
map Q <Nop>

" UI
set ruler
set laststatus=2

" Vundle it up
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Utility
Bundle 'gmarik/vundle'
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'tpope/vim-fugitive'
Bundle 'EvanDotPro/nerdtree-chmod'
Bundle 'Shougo/vimproc'
Bundle 'Shougo/unite.vim'
"Bundle 'SirVer/ultisnips'
Bundle 'benekastah/neomake'

" OS Integration
Bundle 'justinmk/vim-gtfo'

" Display
Bundle 'bling/vim-airline'
Bundle 'airblade/vim-gitgutter'
Bundle 'majutsushi/tagbar'

" Editing
Bundle 'vim-scripts/a.vim'
Bundle 'vim-scripts/paredit.vim'
Bundle 'sjl/gundo.vim'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'b4winckler/vim-angry.git'
Bundle 'gregsexton/MatchTag'
Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-indent'
Bundle 'Julian/vim-textobj-variable-segment'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'
Bundle 'AndrewRadev/splitjoin.vim'

" Python
Bundle 'alfredodeza/pytest.vim'
"Bundle 'klen/python-mode'
Bundle 'davidhalter/jedi-vim'

" C++
Bundle 'Rip-Rip/clang_complete'

" JS
Bundle 'marijnh/tern_for_vim'

" File Types
Bundle 'sheerun/vim-polyglot'
Bundle 'vim-scripts/mail.vim'
Bundle 'elzr/vim-json'
Bundle 'avakhov/vim-yaml'
Bundle 'othree/html5.vim'
Bundle 'moll/vim-node'
Bundle 'chase/vim-ansible-yaml'
Bundle 'mustache/vim-mustache-handlebars'

" Colors
Bundle 'nanotech/jellybeans.vim'
Bundle 'NLKNguyen/papercolor-theme'
Bundle 'vim-scripts/summerfruit256.vim'
Bundle 'vim-scripts/colour-sampler-pack'
Bundle 'vim-scripts/scrollcolors'



" Keep this after Bundles else it breaks Ultisnips
filetype plugin indent on

" Syntax hilighting
syntax on

" Languages embedded in other ones.
function! TextEnableCodeSnip(filetype,start,end,textSnipHl) abort
  let ft=toupper(a:filetype)
  let group='textGroup'.ft
  if exists('b:current_syntax')
    let s:current_syntax=b:current_syntax
    " Remove current syntax definition, as some syntax files (e.g. cpp.vim)
    " do nothing if b:current_syntax is defined.
    unlet b:current_syntax
  endif
  execute 'syntax include @'.group.' syntax/'.a:filetype.'.vim'
  try
    execute 'syntax include @'.group.' after/syntax/'.a:filetype.'.vim'
  catch
  endtry
  if exists('s:current_syntax')
    let b:current_syntax=s:current_syntax
  else
    unlet b:current_syntax
  endif
  execute 'syntax region textSnip'.ft.'
  \ matchgroup='.a:textSnipHl.'
  \ start="'.a:start.'" end="'.a:end.'"
  \ contains=@'.group
endfunction

au filetype cpp call TextEnableCodeSnip('glsl', 'R\"( // GLSL', ')\"', 'cppRawString')



" Indentation
set shiftround
set expandtab
set smarttab
set backspace=indent,eol,start
set autoindent
set copyindent

" Customize C formatting
set cinkeys-=0# " No electric hash key
set cino+=Ls " Labels outdented once
set cino+=l1 " Case labels count as a thing to align to
set cino+=c1s " Indent comment blocks properly

set softtabstop=4
set shiftwidth=4

au filetype javascript setlocal softtabstop=2 shiftwidth=2
au filetype lua        setlocal softtabstop=2 shiftwidth=2
au filetype html       setlocal softtabstop=2 shiftwidth=2
au filetype htmldjango setlocal softtabstop=2 shiftwidth=2
au filetype css        setlocal softtabstop=2 shiftwidth=2
au filetype scss       setlocal softtabstop=2 shiftwidth=2
au filetype gitcommit  setlocal tw=72
au filetype z80        setlocal softtabstop=12 shiftwidth=12

" Make csscolors work with sass
au filetype scss       syntax cluster sassCssAttributes add=@cssColors

" Break da rulez
au BufRead,BufNewFile urls.py set tw=0

" File name mappings
au BufNewFile,BufRead SConstruct set ft=python
au BufNewFile,BufRead *.cg set ft=cg
au BufNewFile,BufRead *.glsl set ft=cg
au BufNewFile,BufRead *.material set ft=ogre
au BufNewFile,BufRead *.program set ft=ogre
au BufNewFile,BufRead *.compositor set ft=ogre
au BufNewFile,BufRead *.particle set ft=ogre
au BufNewFile,BufRead *.hbs set ft=mustache
au BufRead,BufNewFile *.html set ft=htmldjango
au BufRead,BufNewFile *.mm set ft=objcpp
au BufRead,BufNewFile *email*.txt set ft=django
au BufRead,BufNewFile *.make set ft=make
au BufRead,BufNewFile *.s set ft=z80
au BufRead,BufNewFile *.z80 set ft=z80

" Searching
set incsearch
set ignorecase
set smartcase
set gdefault
set grepprg=ag

" Filenames
set wildmode=longest,list
set wildignore+=.sass-cache
set wildignore=*.o,*.obj,build,out,*.pyc,htmlcov,migrations
set wildignore+=node_modules,bower_components,vendor,ve
set wildignore+=*.png,*.tga,*.blend,*.wav,*.psd,*.scssc,__pycache__

" Formatting
set nowrap
set list
set listchars=tab:\|\ ,trail:•,extends:→,nbsp:·
if has('win32')
    if has('gui_running') == 0
        set listchars=tab:>\ ,trail:.,extends:>,nbsp:-
    endif
endif
set formatoptions=qnl1
set colorcolumn=+1
set textwidth=80

" No comment stars
au FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
au FileType c,cpp setlocal comments-=:// comments+=f://

" C++11
let c_no_curly_error=1

" -- PLUGINS -------------------------------------------------------------------


" A.vim
let g:alternateExtensions_m = "h"
let g:alternateExtensions_mm = "h"
let g:alternateExtensions_h = "c,cc,cpp,cxx,m,mm"

" Airline
let g:airline_powerline_fonts = 0

" NetRW
let g:netrw_hide = 1
let g:netrw_list_hide = '\.pyc$'
let g:netrw_silent = 1

" Tagbar Plugin
let g:tagbar_ctags_bin = '/usr/local/bin/ctags'

" Python-mode Plugin
let g:pymode_folding=0
let g:pymode_rope_guess_project=0
let g:pymode_lint=1
let g:pymode_rope_complete_on_dot=0
let g:pymode_lint_cwindow=0
let g:pymode_lint_ignore = "E501,E121,E126,E127,E128,W0404"
let g:pymode_virtualenv = 1

" Jedi
let g:jedi#smart_auto_mappings = 0
let g:jedi#popup_on_dot = 0
let g:jedi#force_py_version = 3

" Rope
let ropevim_vim_completion = 1
let ropevim_extended_complete = 1
let g:ropevim_autoimport_modules = ["os.*", "django.*"]

" Unite
call unite#custom#source('file_rec/async', 'ignore_globs', split(&wildignore, ','))
call unite#custom#source('file_rec/async', 'ignore_pattern', '\.scssc\|node_modules\|bower_components\|\.idea\|\.sass-cache\|\.android\|__pycache__')

" A very useful but disastrously-named plugin for opening files
nmap <C-p> :CtrlP<CR>
nmap <leader>f :CtrlPClearAllCaches<CR>
let g:ctrlp_switch_buffer = 0
let g:ctrlp_dont_split = '.*'
let g:ctrlp_extensions = ['line']
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_prompt_mappings = {
    \ 'PrtSelectMove("j")':   ['<c-j>', '<c-n>', '<down>'],
    \ 'PrtSelectMove("k")':   ['<c-k>', '<c-p>', '<up>'],
    \ 'PrtHistory(-1)':       ['<down>'],
    \ 'PrtHistory(1)':        ['<up>'] }

" GitGutter
nmap ]g :GitGutterNextHunk<CR>
nmap [g :GitGutterPrevHunk<CR>
let g:gitgutter_eager = 0

" NerdTree
let NERDTreeIgnore=['\.pyc\|\.cs\.meta$']
let NERDTreeMinimalUI=1
let NERDTreeMapHelp='<f1>'

" What is it with vim and shitty names
nmap <C-l> :A<CR>

" Syntastic
let g:syntastic_cpp_compiler = 'clang++'
let g:syntastic_cpp_compiler_options = ' -std=c++11 -stdlib=libc++'
let g:syntastic_clang_check_config_file = '.clang_complete'
let g:syntastic_cpp_config_file = '.clang_complete'
let g:syntastic_python_python_exec = 'python3'

" Clang Complete
" Disable auto completion, always <c-x> <c-o> to complete
let g:clang_complete_auto = 0
let g:clang_use_library = 1
let g:clang_periodic_quickfix = 0
let g:clang_close_preview = 1
let g:clang_complete_macros = 1
let g:clang_complete_patterns = 1

" For Objective-C, this needs to be active, otherwise multi-parameter methods won't be completed correctly
let g:clang_snippets = 1

" Snipmate does not work anymore, ultisnips is the recommended plugin
" let g:clang_snippets_engine = 'ultisnips'

" This might change depending on your installation
let g:clang_exec = '/usr/bin/clang'
let g:clang_library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib'
let g:clang_user_options = '-IClangCompleteInclude'


" -- KEY MAPPINGS --------------------------------------------------------------

nnoremap \ ,
let mapleader = ","

" Normal Mode
nmap <C-S> :w<CR>

nmap <silent> <leader>v :e $MYVIMRC<CR>
nmap <silent> <leader>r :so $MYVIMRC<CR>
nmap <leader>h :set invhlsearch<CR>
nmap <leader>r :so $MYVIMRC<CR>
nmap <leader>t :TagbarToggle<CR>
nmap <leader>a :PymodeLintAuto<CR>
nmap <leader>p :set ft=python<CR>:PymodeRun<CR>
nmap <leader>1 :e %:p:h<CR>
nmap <leader>2 :e .<CR>
nmap <leader>m :silent make<CR>

" Delete and collapse
nmap <leader>d :set opfunc=DeleteAndCollapse<CR>g@
vmap <leader>d :d<CR>?.<CR>jd/.<CR>O<ESC>

function! DeleteAndCollapse(type, ...)
    silent exe "'[,']d"
    silent exe "normal ?.\<CR>jd/.\<CR>O\<ESC>"
endfunction

if has('win32')
    nmap <C-T> :tabnew<CR>
    nmap <leader>w :tabclose<CR>
end

" JSON

function! JSON()
    silent exe "%!jq ."
    silent exe "set ft=json"
endfunction

" Insert Mode
imap <c-space> <C-R>=RopeCodeAssistInsertMode()<CR>

" Command Mode
cmap %% %:p:h

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif

if has('gui_running')
    set go-=r go-=R go-=l go-=L go+=m

    if has('mac')
        set guifont=Monaco:h13
    endif
endif
colors jellybeans
