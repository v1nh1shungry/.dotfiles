" ============================================================================
" ========================== Basic Settings ==================================
" ============================================================================
let mapleader = ' '

set shortmess+=I
set number
set relativenumber
set noshowmode
set hidden
set ignorecase
set smartcase
set noerrorbells visualbell t_vb=
set expandtab
set nowrap
set splitbelow
set splitright
set nowritebackup
set noswapfile
set showcmd
set hlsearch
set scrolloff=10

inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>
cnoremap <C-h> <left>
cnoremap <C-j> <down>
cnoremap <C-k> <up>
cnoremap <C-l> <right>
inoremap <silent> <C-S> <cmd>w!<CR>
nnoremap <silent> <C-S> <cmd>w!<CR>
nnoremap <silent> q <cmd>q<CR>
nnoremap <silent> Q <cmd>qa!<CR>
nnoremap <silent> <C-q> <cmd>bd<CR>

autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \	 exe "normal! g`\"" |
    \ endif

" ============================================================================
" ============================= Plugins' Setting =============================
" ============================================================================

" + vim-plug
call plug#begin()
" +--+ Basic Enhancement
Plug 'tpope/vim-sensible'
Plug 'sheerun/vim-polyglot'
Plug 'andymass/vim-matchup'
Plug 'romainl/vim-cool'
Plug 'markonm/traces.vim'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-unimpaired'
Plug 'wellle/context.vim'
Plug 'gelguy/wilder.nvim'
Plug 'kshenoy/vim-signature'
Plug 'simeji/winresizer'
Plug 'skywind3000/vim-terminal-help'
Plug 'dstein64/vim-startuptime', { 'on': 'StartupTime' }
" |  +--- Text Objects
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object'
" +--- Edit Enhancement
Plug 'tpope/vim-rsi'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'AndrewRadev/splitjoin.vim', { 'on': ['SplitjoinSplit', 'SplitjoinJoin'] }
Plug 'matze/vim-move'
" +--+ Beautify
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'ryanoasis/vim-devicons'
" |  +--- Theme
Plug 'tomasiser/vim-code-dark'
" +--+ Programming Enhancement
Plug 'mhinz/vim-signify'
Plug 'Yggdroot/indentLine'
Plug 'luochen1990/rainbow'
Plug 'skywind3000/asynctasks.vim', { 'on': 'AsyncTask' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'puremourning/vimspector', { 'for': ['c', 'cpp', 'rust', 'zig'] }
Plug 'metakirby5/codi.vim', { 'on': 'Codi!!' }
Plug 'segeljakt/vim-silicon', { 'on': 'Silicon' }
"    +--- Languages
Plug 'skywind3000/vim-cppman', { 'for': ['c', 'cpp'] }
Plug 'v1nh1shungry/vim-cppinsights', { 'for': 'cpp' }
Plug 'alvan/vim-closetag', { 'for': ['html', 'xml'] }
Plug 'ap/vim-css-color'
call plug#end()

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
    \     'guifgs': ['#f1d700', '#da70d6', '#199dff'],
    \     'separately': {
    \         'nerdtree': 0,
    \     }
    \ }

" indentLine
let g:indentLine_bufTypeExclude = ['help', 'terminal']
let g:indentLine_bufNameExclude = ['/dev/.*', 'man.*']
let g:indentLine_fileTypeExclude = ['startify', 'coc-explorer']

" coc.nvim
let g:airline#extensions#coc#error_symbol = ' '
let g:airline#extensions#coc#warning_symbol = '⚠ '
set updatetime=100
set shortmess+=c
set signcolumn=yes
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gh :call CocActionAsync('doHover')<CR>
nnoremap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <leader>f :call CocActionAsync('format')<CR>
xnoremap <silent> <leader>a  <Plug>(coc-codeaction-selected)
nnoremap <silent> <leader>a  <Plug>(coc-codeaction-selected)
nnoremap <silent> <leader>ac  <Plug>(coc-codeaction)
nnoremap <silent> <leader>qf  <Plug>(coc-fix-current)
xnoremap if <Plug>(coc-funcobj-i)
onoremap if <Plug>(coc-funcobj-i)
xnoremap af <Plug>(coc-funcobj-a)
onoremap af <Plug>(coc-funcobj-a)
xnoremap ic <Plug>(coc-classobj-i)
onoremap ic <Plug>(coc-classobj-i)
xnoremap ac <Plug>(coc-classobj-a)
onoremap ac <Plug>(coc-classobj-a)
nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"
nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"
inoremap <silent><nowait><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) :
                                    \ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Down>"
inoremap <silent><nowait><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) :
                                    \ coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Up>"
nnoremap <silent> <leader>o  :call ToggleOutline()<CR>
function! ToggleOutline() abort
    let winid = coc#window#find('cocViewId', 'OUTLINE')
    if winid == -1
        call CocActionAsync('showOutline', 1)
    else
        call coc#window#close(winid)
    endif
endfunction
nnoremap <silent> <leader>x  :<C-u>CocList extensions<cr>
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')

" coc-snippets
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ CheckBackspace() ? "\<TAB>" :
    \ coc#refresh()
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_next = '<tab>'

" coc-tasks
nnoremap <silent> <leader>t  :<C-u>CocList tasks<cr>

" coc-lists
nnoremap <silent> <leader>h :<C-u>CocList helptags<cr>

" coc-explorer
nnoremap <silent> <leader>e <Cmd>CocCommand explorer<CR>

" vim-startify
let g:startify_custom_header =
    \ startify#center(split(system('cat ~/.dotfiles/vim/banner.txt'), '\n'))
let g:startify_lists = [
    \ { 'type': 'files',     'header': ['   Recent Files' ] },
    \ { 'type': 'sessions',  'header': ['   Sessions'     ] },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks'    ] },
    \ { 'type': 'commands',  'header': ['   Commands'     ] },
    \ ]

" vim-terminal-help
let g:terminal_cwd = 2
let g:terminal_kill = 1

" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <silent> <Leader>di <Plug>VimspectorBalloonEval
xnoremap <silent> <Leader>di <Plug>VimspectorBalloonEval

" asynctasks
let g:asyncrun_open = 6
let g:asynctasks_term_reuse = 1
let g:asynctasks_term_pos = 'termhelp'
let g:asynctasks_template = '~/.vim/tasks_template.ini'
noremap <silent> <leader>fb :AsyncTask file-build<CR>
noremap <silent> <leader>fr :AsyncTask file-run<CR>
noremap <silent> <leader>pf :AsyncTask project-configure<CR>
noremap <silent> <leader>pb :AsyncTask project-build<CR>
noremap <silent> <leader>pr :AsyncTask project-run<CR>
noremap <silent> <leader>pc :AsyncTask project-clean<CR>

" wilder.nvim
let s:wilder_accent_hl = wilder#make_hl('WilderAccent', 'Pmenu',
        \ [ {},
        \   {'foreground': 'darkred', 'bold': 1},
        \   {'foreground': '#f4468f', 'bold': 1}
        \ ])
let s:wilder_selected_accent_hl = wilder#make_hl('WilderSelectedAccent', 'PmenuSel',
        \ [ {},
        \   {'foreground': 'darkred', 'bold': 1},
        \   {'foreground': '#f4468f', 'bold': 1}
        \ ])
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
    \     wilder#branch(
    \         wilder#cmdline_pipeline({
    \             'language': 'vim',
    \             'fuzzy': 1,
    \             'fuzzy_filter': wilder#vim_fuzzy_filter(),
    \         }),
    \         wilder#vim_search_pipeline()
    \     ),
    \ ])
call wilder#set_option('renderer', wilder#renderer_mux({
    \ ':': wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
            \ 'highlighter': wilder#basic_highlighter(),
            \ 'highlights': {
            \   'accent': s:wilder_accent_hl,
            \   'border': 'Normal',
            \   'selected_accent': s:wilder_selected_accent_hl,
            \ },
            \ 'left': [
            \   ' ', wilder#popupmenu_devicons(),
            \ ],
            \ 'right': [
            \   ' ', wilder#popupmenu_scrollbar(),
            \ ],
            \ 'border': 'rounded',
    \ })),
    \ '/': wilder#wildmenu_renderer(
            \ wilder#wildmenu_airline_theme({
            \   'highlighter': wilder#basic_highlighter(),
            \   'highlights': {
            \       'accent': s:wilder_accent_hl,
            \       'selected_accent': s:wilder_selected_accent_hl,
            \   },
            \ })),
    \ }))

" vim-cppman
autocmd FileType c,cpp setlocal keywordprg=:Cppman

" vim-easymotion
let g:EasyMotion_verbose = 0
let g:EasyMotion_smartcase = 1
map <Leader> <Plug>(easymotion-prefix)
map s <Plug>(easymotion-bd-f2)
map f <Plug>(easymotion-bd-f)

" vim-better-whitespace
let g:better_whitespace_guicolor = 'lightgreen'
let g:better_whitespace_ctermcolor = 'lightgreen'
let g:better_whitespace_filetypes_blacklist=['startify', 'help']

" glyph-palette.vim
autocmd FileType startify,coc-explorer call glyph_palette#apply()

" ============================================================================
" ================================ Theme =====================================
" ============================================================================

autocmd ColorScheme * call Highlight()
function! Highlight() abort
    hi CocErrorHighlight cterm=bold,undercurl ctermfg=Red
    hi CocInlayHint ctermfg=White ctermbg=DarkGrey
endfunction

" Choose the theme
set background=dark
colorscheme codedark
let g:airline_theme = 'codedark'

" Enable true color in TMUX [MUST BE AFTER COLORSCHEME]
if !empty($TMUX)
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

" ============================================================================
" ================================ Languages =================================
" ============================================================================
autocmd FileType bash,fish,sh,vim setlocal shiftwidth=4 softtabstop=4
autocmd FileType markdown setlocal wrap
