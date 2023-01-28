" vim:set ts=2 sts=2 sw=2 expandtab:

" remove all existing autocmds
autocmd!

" initialize plugins
call plug#begin('~/.vim/plugged')

" Vim stuff
Plug 'tpope/vim-sensible' " sensible defaults
Plug 'tpope/vim-sleuth' " shiftwidth and tabwidth management
Plug 'slim-template/vim-slim' " color highlights
Plug 'romainl/vim-cool' " better search instead of <CR>noh
Plug 'tpope/vim-commentary' " multi-line comments

" JavaScript
Plug 'MaxMEllon/vim-jsx-pretty' " JSX highlgihting and formatting

" TypeScript
Plug 'leafgarland/typescript-vim'
" TypeScript semantic support
Plug 'Quramy/tsuquyomi'
Plug 'w0rp/ale'

" Copilot
Plug 'github/copilot.vim'

" Color schemes
Plug 'jonathanfilip/vim-lucius'

call plug#end()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING CONFIGURATION
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
" allow unsaved background buffers and remember marks/undo for them
set hidden
" remember more commands and search history
set history=10000
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set laststatus=2
set showmatch
set incsearch
set hlsearch
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=1
set switchbuf=useopen
" Always show tab bar at the top
set showtabline=2
set winwidth=79
" This makes RVM work inside Vim. I have no idea why.
set shell=bash
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
" set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" Don't make backups at all
set nobackup
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" Enable highlighting for syntax
syntax on
" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
" make tab completion for files/buffers act like bash
set wildmenu
let mapleader=","
" Fix slow O inserts
:set timeout timeoutlen=1000 ttimeoutlen=100
" Normally, Vim messes with iskeyword when you open a shell file. This can
" leak out, polluting other file types even after a 'set ft=' change. This
" variable prevents the iskeyword change so it can't hurt anyone.
let g:sh_noisk=1
" Modelines (comments that set vim options on a per-file basis)
set modeline
set modelines=3
" Turn folding off for real, hopefully
set foldmethod=manual
set nofoldenable
" Insert only one space when joining lines that contain sentence-terminating
" punctuation like `.`.
set nojoinspaces
" If a file is changed outside of vim, automatically reload it without asking
set autoread
" Use the old vim regex engine (version 1, as opposed to version 2, which was
" introduced in Vim 7.3.969). The Ruby syntax highlighting is significantly
" slower with the new regex engine.
set re=1
" Stop SQL language files from doing unholy things to the C-c key
let g:omni_sql_no_default_maps = 1
" Diffs are shown side-by-side not above/below
set diffopt=vertical
" Always show the sign column
set signcolumn=no
" True color mode! (Requires a fancy modern terminal, but iTerm works.)
:set termguicolors
" Write swap files to disk and trigger CursorHold event faster (default is
" after 4000 ms of inactivity)
:set updatetime=200
" Completion options.
"   menu: use a popup menu
"   preview: show more info in menu
:set completeopt=menu,preview
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

" Use persistent undo history.
if !isdirectory("/tmp/.vim-undo-dir")
    call mkdir("/tmp/.vim-undo-dir", "", 0700)
endif
set undodir=/tmp/.vim-undo-dir
set undofile


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  " autocmd FileType html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()

  " *.md is markdown
  autocmd! BufNewFile,BufRead *.md setlocal ft=

  " indent slim two spaces, not four
  autocmd! FileType slim set sw=2 sts=2 et

  " javascript
  autocmd! FileType javascript set sw=2 sts=2 expandtab

  " Expand tabs in Go. Was gofmt raised in a barn?!
  autocmd! FileType go set sw=4 sts=4 expandtab | retab

  " Two-space indents in json
  autocmd! FileType json set sw=2 sts=2 expandtab

  " Hitting K in a Ruby file opens rdoc, which completely breaks the terminal
  " to the point of having to kill vim and do `reset`. Unmap it entirely.
  nnoremap K <Nop>

  " Compute syntax highlighting from beginning of file. (By default, vim only
  " looks 200 lines back, which can make it highlight code incorrectly in some
  " long files.)
  autocmd BufEnter * :syntax sync fromstart

  " Vim 8.2 adds built-in JSX support which seems broken. Setting these
  " filetypes lets the installed plugins deal with JSX/TSX instead.
  autocmd bufnewfile,bufread *.tsx set filetype=typescript.tsx
  autocmd bufnewfile,bufread *.jsx set filetype=javascript.jsx
augroup END


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOR
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" :set t_Co=256 " 256 colors
:color grb-lucius
GrbLuciusDarkHighContrast

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" VIM-ALE CONFIG
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_linters = {'javascript': [], 'typescript': ['tsserver', 'eslint'], 'typescript.tsx': ['tsserver', 'eslint']}
let g:ale_fixers = {'javascript': [], 'typescript': ['prettier'], 'typescript.tsx': ['prettier']}
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_delay = 0
let g:ale_set_quickfix = 0
let g:ale_set_loclist = 0
let g:ale_javascript_eslint_executable = 'eslint --cache'
nnoremap gj :ALENextWrap<cr>
nnoremap gk :ALEPreviousWrap<cr>
nnoremap g1 :ALEFirst<cr>
" This mapping will kill all ALE-related processes (including tsserver). It's
" necessary when those processes get confused. E.g., tsserver will sometimes
" show type errors that don't actually exist. I don't know exactly why that
" happens yet, but I think that it's related to renaming files.
nnoremap g0 :ALEStopAllLSPs<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tsuquyomi
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim-ale handles TypeScript quickfix, so tell Tsuquyomi not to do it.
let g:tsuquyomi_disable_quickfix = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map <leader>y "*y
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
inoremap <c-c> <esc>
" <leader><leader> is more convenient than <c-^>
nnoremap <leader><leader> <c-^>
" Align selected lines
vnoremap <leader>ib :!align<cr>
" Close all other splits
nnoremap <leader>o :only<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MULTIPURPOSE TAB KEY
" Indent if we're at the beginning of a line. Else, do completion.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! InsertTabWrapper()
    let col = col('.') - 1
    if !col
        return "\<tab>"
    endif

    let char = getline('.')[col - 1]
    if char =~ '\k'
        " There's an identifier before the cursor, so complete the identifier.
        return "\<c-p>"
    else
        return "\<tab>"
    endif
endfunction
inoremap <expr> <tab> InsertTabWrapper()
inoremap <s-tab> <c-n>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SHORTCUT TO REFERENCE CURRENT FILE'S PATH IN COMMAND LINE MODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
cnoremap <expr> %% expand('%:h').'/'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RENAME CURRENT FILE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")

  if filereadable("bin/test_alternative_for_file")
    let alt_file = system("bin/test_alternative_for_file " . current_file)
    return alt_file
  end

  let is_js = match(current_file, '\.js$') != -1
  let is_ts = match(current_file, '\.tsx\?$') != -1
  let is_php = match(current_file, '\.php$') != -1
  let is_rb = match(current_file, '\.e\?rb$') != -1

  let in_test_file = match(current_file, '^spec/') != -1
        \ || match(current_file, '\.spec\.js$') != -1
        \ || match(current_file, 'Test\.php$') != -1
        \ || match(current_file, '__tests__') != -1
  let in_app_subdir = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1 || match(current_file, '\<service\>') != -1 || match(current_file, '<\extensions\>') != 1

  let alt_file = current_file
  if is_js
    if in_test_file
      let alt_file = substitute(alt_file, '\.spec\.js$', '.js', '')
    else
      let alt_file = substitute(alt_file, '\.js$', '.spec.js', '')
    endif
  elseif is_ts
    if in_test_file
      let alt_file = substitute(alt_file, '__tests__/', '', '')
    else
      let basename = expand('%:t:r') . '.' . expand('%:e')
      let alt_file = substitute(alt_file, basename, '__tests__/' . basename, '')
    endif
  elseif is_php
    if in_test_file
      let alt_file = substitute(alt_file, 'tests/', '', '')
      if in_app_subdir
        let alt_file = 'app/' . alt_file
      endif
      let alt_file = substitute(alt_file, 'Test\.php$', '.php', '')
    else
      if in_app_subdir
        let alt_file = substitute(alt_file, 'app/', '', '')
      endif
      let alt_file = 'tests/' . alt_file
      let alt_file = substitute(alt_file, '\.php$', 'Test\.php', '')
    endif
  elseif is_rb
    if in_test_file
      let alt_file = substitute(alt_file, 'spec/', '', '')
      if in_app_subdir
        let alt_file = 'app/' . alt_file
      endif
      let alt_file = substitute(alt_file, '_spec\.rb$', '.rb', '')
    else
      if in_app
        let alt_file = substitute(alt_file, 'app/', '', '')
      endif
      let alt_file = substitute(alt_file, '\.e\?rb$', '_spec.rb', '')
      let alt_file = 'spec/' . alt_file
    endif
  endif

  return alt_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" RUNNING TESTS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>t :call RunTestFile()<cr>
nnoremap <leader>T :call RunNearestTest()<cr>
nnoremap <leader>a :call RunTests('')<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

" Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(spec.\(tsx\=\|jsx\=\|rb\)\|_test.rb\|test_.*\.py\|_test.py\|.test.tsx*\|__tests__.*\.tsx\=\|__tests__.*\.jsx\=\)$') != -1
    if in_test_file
        call SetTestFile(command_suffix)
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file)
endfunction

function! SetTestFile(command_suffix)
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@% . a:command_suffix
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    if expand("%") != ""
      :w
    end
    " The file is executable; assume we should run
    if executable(a:filename)
      exec ":!./" . a:filename
    " " Project-specific test scripts
    " elseif filereadable("bin/test_single")
    "   exec ":!bin/test_single " . a:filename
    elseif filereadable("bin/test")
      exec ":!bin/test " . a:filename
    " Rspec binstub
    elseif filereadable("bin/rspec")
      exec ":!bin/rspec " . a:filename
    " Fall back to a blocking test run with Bundler
    elseif filereadable("bin/rspec")
      exec ":!bin/rspec --color " . a:filename
    elseif filereadable("Gemfile") && strlen(glob("spec/**/*.rb"))
      exec ":!bundle exec rspec --color " . a:filename
    elseif filereadable("Gemfile") && strlen(glob("test/**/*.rb"))
      exec ":!bin/rails test " . a:filename
    " If we see python-looking tests, assume they should be run with Nose
    elseif strlen(glob("test/**/*.py") . glob("tests/**/*.py"))
      exec "!nosetests " . a:filename
    end
endfunction


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Refactoring mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>rn :TsuRenameSymbol<cr>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Selecta Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Run a given vim command on the results of fuzzy selecting from a given shell
" command. See usage below.
function! SelectaCommand(choice_command, selecta_args, vim_command)
  try
    exec a:vim_command . " " . SelectaOutput(a:choice_command, a:selecta_args)
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
endfunction

function! SelectaOutput(choice_command, selecta_args)
  let selection = system(a:choice_command . " | selecta " . a:selecta_args)
  " Escape spaces in the file name. That ensures that it's a single argument
  " when concatenated with vim_command and run with exec.
  let selection = substitute(selection, ' ', '\\ ', "g")
  redraw!
  return selection
endfunction

function! SelectaFile(path, glob, command)
  call SelectaCommand("fd -t f . " . a:path, "", a:command)
endfunction

function! SelectaFileContents()
  try
    let selection = SelectaOutput("ls src/**/*.ts* | while read fn; do nl -b a \"$fn\" | while read line; do echo \"$fn:$line\"; done; done", "| cut -d \"	\" -f 1")
  catch /Vim:Interrupt/
    " Swallow the ^C so that the redraw below happens; otherwise there will be
    " leftovers from selecta on the screen
    redraw!
    return
  endtry
  exec substitute(selection, "^\\([^:]\\+\\):\\([0-9]\\+\\).*$", ":e +\\2 \\1", "")
endfunction

nnoremap <leader>f :call SelectaFile(".", "*", ":edit")<cr>
nnoremap <leader>F :call SelectaFileContents()<cr>
nnoremap <leader>e :call SelectaFile(expand('%:h'), "*", ":edit")<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Typescript Mappings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>d :TsuDefinition<cr>
nnoremap <leader>D :TsuTypeDefinition<cr>
nnoremap <leader>c :Copilot<cr>

"Fuzzy select
function! SelectaIdentifier()
  " Yank the word under the cursor into the z register
  normal "zyiw
  " Fuzzy match files in the current directory, starting with the word under
  " the cursor
  call SelectaCommand("find * -type f", "-s " . @z, ":e")
endfunction
nnoremap <c-g> :call SelectaIdentifier()<cr>


