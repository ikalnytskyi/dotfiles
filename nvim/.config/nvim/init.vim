"
" Author: Ihor Kalnytskyi <ihor@kalnytskyi.com>
" Source: https://raw.githubusercontent.com/ikalnytskyi/dotfiles/master/nvim/.config/nvim/init.vim
"

scriptencoding utf-8

" VIMHOME should point to ~/.config/nvim directory and is used as a general
" way to retrieve a path to NeoVim goodies.
let $VIMHOME=fnamemodify($MYVIMRC, ':h')

"
" // PLUGINS //
"

if !filereadable($VIMHOME . '/autoload/plug.vim')
  if executable('curl')
    silent! !curl -fLo $VIMHOME/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * silent! PlugInstall --sync | source $MYVIMRC
  endif
endif

if !filereadable($VIMHOME . '/tmp/runtime/py3/bin/python')
  try
    if executable('virtualenv')
      !virtualenv -ppython3 $VIMHOME/tmp/runtime/py3
    elseif executable('python3')
      !python3 -m venv $VIMHOME/tmp/runtime/py3
    endif
  finally
    !$VIMHOME/tmp/runtime/py3/bin/pip install pynvim
  endtry
endif
let g:python3_host_prog = $VIMHOME . '/tmp/runtime/py3/bin/python'

try
  python3 import pynvim
catch
  echomsg "please ensure 'pynvim' is installed in your python environment"
endtry

silent! if plug#begin($VIMHOME . '/plugins')
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'scrooloose/nerdtree'
  Plug 'liuchengxu/vista.vim'
  Plug 'mhinz/vim-grepper'
  Plug 'tpope/vim-fugitive'
  Plug 'mhinz/vim-signify'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'terryma/vim-multiple-cursors'
  Plug 'Valloric/ListToggle'
  Plug 'godlygeek/tabular'
  Plug 'arcticicestudio/nord-vim'
  Plug 'tpope/vim-sleuth'

  Plug 'ncm2/ncm2'
  Plug 'roxma/nvim-yarp'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'ncm2/ncm2-vim-lsp'
  Plug 'ncm2/ncm2-bufword'

  if exists('*nvim_open_win')
    Plug 'ncm2/float-preview.nvim'
  endif

  Plug 'cespare/vim-toml', {'for': ['toml']}
  Plug 'iloginow/vim-stylus', {'for': ['stylus']}
  Plug 'leafgarland/typescript-vim', {'for': ['typescript']}
  Plug 'octol/vim-cpp-enhanced-highlight', {'for': ['cpp']}
  Plug 'pangloss/vim-javascript', {'for': ['javascript']}
  Plug 'plasticboy/vim-markdown', {'for': ['markdown']}
  Plug 'Glench/Vim-Jinja2-Syntax', {'for': ['jinja']}

  call plug#end()

  " ~ ncm2/float-preview.nvim

  let g:float_preview#docked = 0

  function! DisableExtras()
    call nvim_win_set_option(g:float_preview#win, 'cursorline', v:false)
    call nvim_win_set_option(g:float_preview#win, 'cursorcolumn', v:false)
  endfunction

  autocmd User FloatPreviewWinOpen call DisableExtras()

  " ~ ctrlpvim/ctrlp.vim

  let g:ctrlp_user_command = {
    \ 'types': {
      \ 1: ['.git', 'git --git-dir=%s/.git ls-files -co --exclude-standard'],
      \ 2: ['.hg', 'hg --cwd %s status -numac -I .'],
    \ },
    \ 'fallback': 'echo ""',
  \ }
  let g:ctrlp_match_window = 'results:0'

  " ~ ncm2/ncm2

  augroup NCM2
    autocmd!
    autocmd BufEnter * silent! call ncm2#enable_for_buffer()
    autocmd User Ncm2Plugin call ncm2#register_source({
      \ 'name' : 'css',
      \ 'priority': 8,
      \ 'subscope_enable': 1,
      \ 'scope': ['css', 'scss', 'less', 'stylus'],
      \ 'mark': 'css',
      \ 'word_pattern': '[\w\-]+',
      \ 'complete_pattern': ':\s*',
      \ 'on_complete': ['ncm2#on_complete#omni', 'csscomplete#CompleteCSS'],
    \ })
  augroup END

  " ~ prabirshrestha/vim-lsp

  let g:lsp_signs_enabled = 0
  let g:lsp_virtual_text_enabled = 0
  let g:lsp_diagnostics_echo_cursor = 1
  let g:lsp_highlights_enabled = 0

  augroup LSP
    autocmd!

    if executable('pyls')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ 'priority': 1,
        \ 'workspace_config': {
          \ 'pyls': {
            \ 'plugins': {
              \ 'flake8': {'enabled': v:true},
              \ 'pycodestyle': {'enabled': v:false},
            \ },
          \ },
        \ },
      \ })
      autocmd FileType python setlocal omnifunc=lsp#complete

      let g:vista_python_executive = "vim_lsp"
    endif

    if executable('clangd')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ 'priority': 1,
      \ })
      autocmd FileType c,cpp setlocal omnifunc=lsp#complete

      let g:vista_c_executive = "vim_lsp"
      let g:vista_cpp_executive = "vim_lsp"
    endif

    if executable('rls')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'whitelist': ['rust'],
        \ 'priority': 1,
      \ })
      autocmd FileType rust setlocal omnifunc=lsp#complete

      let g:vista_rust_executive = "vim_lsp"
    endif

    if executable('bash-language-server')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'whitelist': ['sh'],
        \ 'priority': 1,
      \ })
      autocmd FileType sh setlocal omnifunc=lsp#complete

      let g:vista_sh_executive = "vim_lsp"
    endif

    if executable('javascript-typescript-stdio')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'jls',
        \ 'cmd': {server_info->['javascript-typescript-stdio']},
        \ 'whitelist': ['javascript', 'typescript'],
        \ 'priority': 1,
      \ })
      autocmd FileType javascript,typescript setlocal omnifunc=lsp#complete

      let g:vista_javascript_executive = "vim_lsp"
      let g:vista_typescript_executive = "vim_lsp"
    endif

    if executable('gopls')
      autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ 'priority': 1,
      \ })
      autocmd FileType go setlocal omnifunc=lsp#complete
    endif
  augroup END

  " ~ scrooloose/nerdtree

  let g:NERDTreeQuitOnOpen = 1

  " ~ liuchengxu/vista.vim

  let g:vista_echo_cursor = 0
  let g:vista_sidebar_width = 30
  let g:vista_close_on_jump = 1
  let g:vista_icon_indent = ["▸ ", ""]
  let g:vista_blink = [0, 0]

  if exists('*nvim_open_win')
    let g:vista_echo_cursor = 1
    let g:vista_echo_cursor_strategy = "floating_win"
  endif

  " ~ mhinz/vim-grepper

  let g:grepper = {
    \ 'dir': 'repo,file',
    \ 'tools': ['git', 'rg', 'ag', 'grep'],
  \ }

  " ~ Valloric/ListToggle

  let g:lt_location_list_toggle_map = '<leader>l'
  let g:lt_quickfix_list_toggle_map = '<leader>q'

  " ~ arcticicestudio/nord-vim

  silent! colorscheme nord

  if !has('gui_running')
    exe "hi! Normal guibg=NONE"
    exe "hi! LineNr guibg=NONE"
  endif

  " ~ pangloss/vim-javascript

  let g:javascript_plugin_jsdoc = 1
  let g:javascript_plugin_flow = 1

  " ~ plasticboy/vim-markdown

  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_conceal = 0
  let g:vim_markdown_auto_insert_bullets = 0
  let g:vim_markdown_new_list_item_indent = 0

endif

"
" // GENERAL //
"

if $COLORTERM == 'truecolor' || $COLORTERM == '24bit'
  set termguicolors
endif

set autochdir                       " change cwd to current file
set colorcolumn=80,100              " show columns at 80 & 100 characters
set completeopt=menuone             " show menu even for a single match
set completeopt+=noinsert,noselect  " do not auto- select/insert completions
set cursorcolumn                    " highlight the column with cursor
set cursorline                      " highlight the line with cursor
set expandtab                       " insert space instead the tab
set formatoptions+=r                " auto insert comment leader on <enter>
set hidden                          " do not abandon buffers, hid them instead
set ignorecase                      " case insensitive search
set lazyredraw                      " do not redraw screen on macros execution, etc
set list                            " show unprintable characters
set listchars=tab:»·,trail:·        " set unprintable characters
set mouse=a                         " enable mouse support in all Vim modes
set mousehide                       " hide mouse cursor when typing
set nofoldenable                    " no code folding, I hate it
set noshowmode                      " do not show Vim mode, airline shows it
set noswapfile                      " do not create swap files
set notimeout                       " no timeout on keybindings (aka mappings)
set nowrap                          " do not wrap lines visually
set number                          " show line numbers
set scrolloff=3                     " start scrolling 3 lines ahead
set shiftwidth=4                    " shift lines by 4 spaces
set shortmess+=c                    " supress 'match X of Y' message
set showbreak=↪                     " character to mark wrapped line
set sidescrolloff=3                 " start scrolling 3 columns ahead
set smartcase                       " match uppercase in the search string
set softtabstop=4                   " insert spaces instead of tabs
set spelllang=en,ru                 " languages to spellcheck
set tabstop=8                       " set tab width
set title                           " propagate useful info to window title
set ttimeout                        " do timeout on key codes
set undofile                        " persistent undo (survives Vim restart)
set visualbell                      " flash screen instead of beep


"
" // KEYBINDINGS //
"

nnoremap <leader>1 :NERDTreeToggle<CR>
nnoremap <leader>2 :Vista!!<CR>
nnoremap <leader>3 :set spell!<CR>
nnoremap <leader>4 :SignatureListBufferMarks<CR>
nnoremap <leader>g :Grepper<CR>
nnoremap <leader>d :LspDefinition<CR>
nnoremap <leader><S-d> :LspPeekDefinition<CR>
nnoremap <leader>h :LspHover<CR>
nnoremap <leader>r :LspReferences<CR>
nnoremap <leader>i :LspDocumentDiagnostics<CR>
nnoremap <leader>s :LspDocumentSymbol<CR>
nnoremap <leader>w :LspWorkspaceSymbols<CR>
nnoremap <leader><S-f> :LspDocumentFormat<CR>
vnoremap <leader><S-f> :LspDocumentRangeFormat<CR>

function! OnEnterPressed()
  return empty(v:completed_item) ? "\<C-y>\<CR>" : "\<C-y>"
endfunction

inoremap <expr> <CR> pumvisible() ? OnEnterPressed() : "\<CR>"
inoremap <expr> <Esc> pumvisible() ? "\<C-e>\<Esc>" : "\<Esc>"
inoremap <expr> <Down> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"
inoremap <expr> <PageUp> pumvisible() ? "\<PageUp>\<C-p>\<C-n>" : "\<PageUp>"

noremap <Leader>y "+y
noremap <Leader>p "+p
noremap <Leader>Y "*y
noremap <Leader>P "*p

"
" // LANGUAGES //
"

augroup FILETYPES
  autocmd!
  autocmd BufReadPost .babelrc setlocal filetype=json
  autocmd BufReadPost .eslintrc setlocal filetype=json
augroup END

augroup PYTHON
  autocmd!
  autocmd FileType python setlocal comments+=b:#:   " sphinx (#:) comments
augroup END
