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
set mouse+=a
set softtabstop=4
set shiftwidth=4
set expandtab
set nowrap
set splitbelow
set splitright
inoremap <silent> <C-S> <ESC>:w<CR>
nnoremap <silent> <C-S> :w<CR>
nnoremap <silent> q :q<CR>
nnoremap <silent> Q :qa!<CR>
nnoremap <silent> <m-.> :bn<CR>
nnoremap <silent> <m-,> :bp<CR>
nnoremap <silent> <m-w> :bd<CR>

" ============================================================================
" ============================= Plugins' Setting =============================
" ============================================================================

" vim-plug
call plug#begin()
Plug 'junegunn/vim-plug'
" Basic Enhancement
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-rsi'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'gelguy/wilder.nvim'
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
" Edit Enhancement
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'AndrewRadev/splitjoin.vim'
" Beautify
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'ryanoasis/vim-devicons'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'tomasiser/vim-code-dark'
" Programming Enhancement
Plug 'mhinz/vim-signify'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'Yggdroot/indentLine'
Plug 'luochen1990/rainbow'
Plug 'skywind3000/vim-terminal-help'
Plug 'skywind3000/asynctasks.vim'
Plug 'skywind3000/asyncrun.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'puremourning/vimspector', { 'for': ['c', 'cpp', 'rust', 'zig'] }
" Languages
Plug 'skywind3000/vim-cppman', { 'for': ['c', 'cpp'] }
Plug 'ziglang/zig.vim', { 'for': 'zig' }
Plug 'v1nh1shungry/vim-cppinsights', { 'for': 'cpp' }
call plug#end()

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" rainbow
let g:rainbow_active = 1
let g:rainbow_conf = {
\   'separately': {
\     'nerdtree': 0,
\   }
\}

" indentLine
let g:indentLine_bufTypeExclude = ['help', 'terminal']
" cppman
let g:indentLine_bufNameExclude = ['/dev/.*', 'man.*']
let g:indentLine_fileTypeExclude = ['startify', 'man']

" coc.nvim
set updatetime=100
let g:airline#extensions#coc#error_symbol = ' '
let g:airline#extensions#coc#warning_symbol = '⚠ '
set shortmess+=c
set signcolumn=yes
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
" Use gh to show documentation in preview window.
nnoremap <silent> gh :call CocActionAsync('doHover')<CR>
" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')
" Symbol renaming.
nmap <silent> <leader>rn <Plug>(coc-rename)
nmap <silent> <leader>f :call CocActionAsync('format')<CR>
augroup cocgroup
    autocmd!
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)
" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)
" Remap <C-j> and <C-k> for scroll float windows/popups.
nnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"
nnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"
inoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"
vnoremap <silent><nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"
" close outline when it's the last window automatically
autocmd BufEnter * call CheckOutline()
function! CheckOutline() abort
    if &filetype ==# 'coctree' && winnr('$') == 1
        if tabpagenr('$') != 1
            close
        else
            bdelete
        endif
    endif
endfunction
" toggle outline
nnoremap <silent><nowait> <space>o  :call ToggleOutline()<CR>
function! ToggleOutline() abort
    let winid = coc#window#find('cocViewId', 'OUTLINE')
    if winid == -1
        call CocActionAsync('showOutline', 1)
    else
        call coc#window#close(winid)
    endif
endfunction

" coc-snippets
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ CheckBackspace() ? "\<TAB>" :
    \ coc#refresh()
let g:coc_snippet_next = '<tab>'

" vim-startify
let g:startify_custom_header =
    \ startify#center(split(system('cat ~/.dotfiles/vim/banner.txt'), '\n'))
let g:startify_lists = [
    \ { 'type': 'files',     'header': ['   Recent Files']   },
    \ { 'type': 'sessions',  'header': ['   Sessions']       },
    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
    \ { 'type': 'commands',  'header': ['   Commands']       },
    \ ]

" vim-terminal-help
let g:terminal_cwd = 2
let g:terminal_kill = 1

" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nmap <silent> <Leader>di <Plug>VimspectorBalloonEval
xmap <silent> <Leader>di <Plug>VimspectorBalloonEval

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

" nerdtree
let NERDTreeQuitOnOpen = 1
nnoremap <silent><leader>n :NERDTreeToggle<CR>
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If more than one window and previous buffer was NERDTree, go back to it.
autocmd BufEnter * if bufname('#') =~# "^NERD_tree_" && winnr('$') > 1 | b# | endif
let g:plug_window = 'noautocmd vertical topleft new'

" wilder.nvim
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
    \   wilder#branch(
    \     wilder#cmdline_pipeline({
    \       'language': 'vim',
    \       'fuzzy': 1,
    \       'fuzzy_filter': wilder#vim_fuzzy_filter(),
    \     }),
    \     wilder#vim_search_pipeline()
    \   ),
    \ ])
call wilder#set_option('renderer', wilder#renderer_mux({
    \ ':': wilder#popupmenu_renderer({
            \ 'highlighter': wilder#basic_highlighter(),
            \ 'left': [
            \ ' ', wilder#popupmenu_devicons(),
            \ ],
            \ 'right': [
            \ ' ', wilder#popupmenu_scrollbar(),
            \ ],
    \ }),
    \ '/': wilder#wildmenu_renderer(
            \ wilder#wildmenu_airline_theme({
            \ 'highlighter': wilder#basic_highlighter(),
            \ 'separator': ' | ',
            \ })),
    \ }))

" nerdtree-git-plugin
let g:NERDTreeGitStatusUseNerdFonts = 1

" vim-cppman
autocmd FileType c,cpp setlocal keywordprg=:Cppman

" vim-easymotion
let g:EasyMotion_verbose = 0

" ============================================================================
" ================================ Theme =====================================
" ============================================================================

autocmd ColorScheme * call Highlight()
function! Highlight() abort
    hi CocErrorHighlight cterm=bold ctermbg=DarkRed ctermfg=White
endfunction

" choose the theme
autocmd vimenter * ++nested colorscheme codedark
let g:airline_theme = 'codedark'

" [MUST BE AFTER COLORSCHEME]
" enable true color
" if exists('+termguicolors')
"     let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"     let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"     set termguicolors
" endif

" ============================================================================
" ================================ Languages =================================
" ============================================================================
autocmd FileType c,cpp setlocal shiftwidth=2 softtabstop=2
autocmd FileType markdown setlocal wrap
