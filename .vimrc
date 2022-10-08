" ============================================================================
" ========================== Basic Settings ==================================
" ============================================================================
let mapleader = ' '
let &t_SI.="\e[6 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[2 q"
let g:netrw_browsex_viewer = system('echo -n $BROWSER')

set hidden
set relativenumber
set noshowmode
set ignorecase
set expandtab
set nowrap
set splitbelow
set splitright
set nowritebackup
set noswapfile
set showcmd
set hlsearch
set helpheight=10
set scrolloff=5
set foldlevel=99
set mouse=a
set shell=/bin/bash

inoremap <C-h> <left>
inoremap <C-j> <down>
inoremap <C-k> <up>
inoremap <C-l> <right>
cnoremap <C-h> <left>
cnoremap <C-j> <down>
cnoremap <C-k> <up>
cnoremap <C-l> <right>
inoremap <silent> <C-S> <ESC>:w<CR>
nnoremap <silent> <C-S> <cmd>w<CR>
nnoremap <silent> q <cmd>q<CR>
nnoremap <silent> Q <cmd>qa!<CR>
nnoremap <silent> <C-q> <cmd>bd<CR>

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
Plug 'skywind3000/vim-terminal-help'
Plug 'lambdalisue/suda.vim', { 'on': ['SudaRead', 'SudaWrite'] }
Plug 'farmergreg/vim-lastplace'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'dhruvasagar/vim-zoom'
" |  +--- Text Objects
Plug 'wellle/targets.vim'
Plug 'kana/vim-textobj-user'
Plug 'adriaanzon/vim-textobj-matchit'
Plug 'kana/vim-textobj-indent'
" +--- Edit Enhancement
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'tommcdo/vim-exchange'
Plug 'sickill/vim-pasta'
" +--+ Beautify
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'skywind3000/vim-quickui'
Plug 'liuchengxu/vista.vim', { 'on': 'Vista!!' }
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'junegunn/limelight.vim', { 'on': 'Limelight' }
" |  +--- Theme
Plug 'wuelnerdotexe/vim-enfocado'
Plug 'srcery-colors/srcery-vim'
" +--+ Programming Enhancement
Plug 'mhinz/vim-signify'
Plug 'Yggdroot/indentLine'
Plug 'skywind3000/asynctasks.vim', { 'on': 'AsyncTask' }
Plug 'skywind3000/asyncrun.vim', { 'on': 'AsyncRun' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
Plug 'puremourning/vimspector', { 'for': ['c', 'cpp', 'rust', 'zig'] }
Plug 'segeljakt/vim-silicon', { 'on': 'Silicon' }
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() }, 'on': 'DogeGenerate' }
Plug 'aperezdc/vim-template'
Plug 'honza/vim-snippets'
"    +--- Git
Plug 'rhysd/committia.vim'
Plug 'tpope/vim-fugitive', { 'on': ['Git', 'Gvdiffsplit', 'Gedit'] }
Plug 'rbong/vim-flog', { 'on': 'Flog' }
"    +--- C/C++
Plug 'skywind3000/vim-cppman', { 'for': ['c', 'cpp'], 'on': 'Cppman' }
Plug 'v1nh1shungry/vim-cppinsights', { 'for': 'cpp', 'on': ['Insights', 'InsightsDiff'] }
"    +--- HTML/CSS/Javascript
Plug 'alvan/vim-closetag', { 'for': ['html', 'xml'] }
Plug 'ap/vim-css-color'
Plug 'turbio/bracey.vim', { 'do': 'npm install --prefix server', 'for': ['html', 'css'], 'on': 'Bracey' }
"    +--- markdown
Plug 'preservim/vim-markdown'
Plug 'preservim/vim-pencil', { 'for': 'markdown' }
"    +--- SQL
Plug 'tpope/vim-dadbod', { 'on': 'DBUIAddConnection' }
Plug 'kristijanhusak/vim-dadbod-ui', { 'on': 'DBUIAddConnection' }
call plug#end()

" vim-airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

" indentLine
let g:indentLine_bufTypeExclude = ['help', 'terminal']
let g:indentLine_bufNameExclude = ['/dev/.*', 'man.*', '__vista__']
let g:indentLine_fileTypeExclude = ['startify', 'coc-explorer']

" coc.nvim
let g:airline#extensions#coc#error_symbol = ' '
let g:airline#extensions#coc#warning_symbol = '⚠ '
let g:airline#extensions#coc#show_coc_status = 0
set updatetime=100
set shortmess+=c
set signcolumn=yes
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                            \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references)
nnoremap <silent> gh <cmd>call CocActionAsync('doHover')<CR>
nnoremap <silent> <leader>rn <Plug>(coc-rename)
nnoremap <silent> <leader>a <Plug>(coc-codeaction-cursor)
nnoremap <silent> <leader>f <Plug>(coc-format)
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
let g:coc_snippet_prev = '<s-tab>'
let g:coc_snippet_next = '<tab>'

" coc-lists
nnoremap <silent> <leader>h <cmd>CocList helptags<cr>

" coc-explorer
nnoremap <silent> <leader>e <Cmd>CocCommand explorer<CR>

" coc-yank
nnoremap <silent> <space>y  <cmd>CocList -A --normal yank<CR>

" vim-startify
let g:startify_custom_header =
    \ startify#center(split(system('cat ~/.dotfiles/vim/banner.txt'), '\n'))

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
noremap <silent> <leader>fb :AsyncTask file-build<CR>
noremap <silent> <leader>fr :AsyncTask file-run<CR>
noremap <silent> <leader>pf :AsyncTask project-configure<CR>
noremap <silent> <leader>pb :AsyncTask project-build<CR>
noremap <silent> <leader>pr :AsyncTask project-run<CR>

" wilder.nvim
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('pipeline', [
    \  wilder#branch(
    \      wilder#cmdline_pipeline({
    \          'language': 'vim',
    \          'fuzzy': 1,
    \          'fuzzy_filter': wilder#vim_fuzzy_filter(),
    \      }),
    \      wilder#vim_search_pipeline()
    \  ),
    \ ])
call wilder#set_option('renderer', wilder#renderer_mux({
    \ ':': wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
            \ 'highlighter': wilder#basic_highlighter(),
            \ 'highlights': {
            \   'border': 'Normal',
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
            \ })),
    \ }))

" vim-easymotion
let g:EasyMotion_verbose = 0
noremap <Leader> <Plug>(easymotion-prefix)

" vim-better-whitespace
let g:better_whitespace_guicolor = 'lightgreen'
let g:better_whitespace_ctermcolor = 'lightgreen'
let g:better_whitespace_filetypes_blacklist = ['startify', 'help', 'git']

" glyph-palette.vim
autocmd FileType startify,coc-explorer call glyph_palette#apply()

" vim-matchup
let g:matchup_matchparen_offscreen = { 'method': '' }

" vim-table-mode
let g:table_mode_corner = '|'

" vim-quickui
let g:quickui_border_style = 2
let g:quickui_show_tip = 1
nnoremap <silent><space><space> <cmd>call quickui#menu#open()<cr>
nnoremap <silent><RightMouse> <cmd>call quickui#context#open(g:context_k, {})<CR>
nnoremap <silent>K <cmd>call CleverK()<CR>
function! CleverK() abort
    if &filetype == 'help'
        call feedkeys('K', 'in')
    else
        call quickui#context#open(g:context_k, {})
    endif
endfunction

" vim-pencil
let g:pencil#wrapModeDefault = 'soft'
autocmd FileType markdown call pencil#init()

" undotree
nnoremap <silent> <leader>u <cmd>UndotreeToggle<CR>

" vista.vim
let g:airline#extensions#vista#enabled = 0
let g:vista_echo_cursor = 0
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista_default_executive = 'coc'
nnoremap <silent><nowait> <leader>o  <cmd>Vista!!<CR>

" vim-enfocado
let g:enfocado_plugins = [
    \ 'coc',
    \ 'glyph-palette',
    \ 'matchup',
    \ 'plug',
    \ 'signify',
    \ 'startify',
    \ 'vista',
    \ 'visual-multi',
    \ ]

" goyo.vim
function! s:goyo_enter()
    if executable('tmux') && strlen($TMUX)
        silent !tmux set status off
    endif
    setlocal noshowcmd
    setlocal scrolloff=0
    Limelight
endfunction
function! s:goyo_leave()
    if executable('tmux') && strlen($TMUX)
        silent !tmux set status on
    endif
    setlocal showcmd
    setlocal scrolloff=10
    Limelight!
endfunction
autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" vim-easy-align
vnoremap <Enter> <Plug>(EasyAlign)
nnoremap ga <Plug>(EasyAlign)

" vim-template
let g:username = system('git config user.name')[:-2]
let g:email = system('git config user.email')[:-2]
let g:templates_no_builtin_templates = 1
let g:templates_directory = '$HOME/.dotfiles/vim/templates/code'

" ============================================================================
" ================================== UI ======================================
" ============================================================================

let g:about_text =
    \ [
        \ "",
    \ ] +
    \ split(system('cat ~/.dotfiles/vim/banner.txt'), '\n') +
    \ [
        \ "",
        \ "Vim is SEXy, and it HEALS my ALL 🤗",
        \ "",
        \ "* Description  : v1nh1shungry's vim configuration",
        \ "* Maintainer   : https://github.com/v1nh1shungry",
        \ "* Repositories : https://github.com/v1nh1shungry/.dotfiles"
    \ ]

call quickui#menu#reset()
call quickui#menu#install('&File', [
        \ ["&Open\t:e", 'call feedkeys(":e ")'],
        \ ["Sudo Open", "call feedkeys(':SudaRead ')", 'Open files with SUDO privilege'],
        \ ["--", ''],
        \ ["&Save\tCTRL + S", 'w'],
        \ ["Save &All", 'wa'],
        \ ["Sudo Save", 'SudaWrite', 'Write files with SUDO privilege'],
        \ ["--", ''],
        \ ["&Exit\tQ", 'qa!'],
      \ ])
call quickui#menu#install('&Edit', [
        \ ["&Strip Trailing", 'StripWhitespace'],
        \ ["--", ''],
        \ ["Explore &Yank History\t<leader>y", 'CocList -A --normal yank'],
        \ ["&Clean Yank History", 'CocCommand yank.clean'],
        \ ["--", ''],
        \ ["&Generate Template", 'Template', 'Generate template codes for current filetype'],
        \ ["&Doge Here\t<leader>d", 'DogeGenerate', 'Generate document comments for current symbol'],
        \ ["&Markdown TOC", 'CocCommand markdown-preview-enhanced.insertTOC', 'Generate TOC under the current cursor'],
        \ ["--", ''],
        \ ["&Table Mode\t<leader>tm", 'TableModeToggle', 'A fancy mode for creating tables'],
        \ ["--", ''],
        \ ["&Format Codes\t<leader>f", "call CocActionAsync('format')"],
      \ ])
call quickui#menu#install('&View', [
        \ ["Switch &Buffer", "call quickui#tools#list_buffer('e')"],
        \ ["Display &Messages", 'call quickui#tools#display_messages()'],
        \ ["--", ''],
        \ ["&Explorer\t<leader>e", 'CocCommand explorer', 'Open file explorer'],
        \ ["&Outline\t<leader>o", 'Vista!!', 'Open symbols outline tree'],
        \ ["&Undotree\t<leader>u", 'UndotreeToggle', 'Open undo history'],
        \ ["&Terminal\tALT + =", "call feedkeys('\<m-=>')"],
        \ ["--", ''],
        \ ["Ma&ximize Current Window\t<C-W>m", "call feedkeys('\<c-w>m')"],
        \ ["&Zen Mode", 'Goyo'],
      \ ])
call quickui#menu#install('&Git', [
        \ ["Git &Status", 'Git'],
        \ ["Git &Diff", 'Gvdiffsplit'],
        \ ["&Browse Branches", 'Flog'],
        \ ["--", ''],
        \ ["Git &Edit", "call feedkeys('Gedit ')", 'View any blob, tree, commit, or tag in the repository'],
      \ ])
call quickui#menu#install('&Build', [
        \ ["Browse &Tasks", 'CocList tasks'],
        \ ["--", ''],
        \ ["File &Compile\t<leader>fb", 'AsyncTask file-build'],
        \ ["File &Execute\t<leader>fr", 'AsyncTask file-run'],
        \ ["--", ''],
        \ ["Project Con&figure\t<leader>pf", 'AsyncTask project-configure'],
        \ ["Project &Build\t<leader>pb", 'AsyncTask project-build'],
        \ ["Project &Run\t<leader>pr", 'AsyncTask project-run'],
        \ ["Project C&lean", 'AsyncTask project-clean']
      \ ])
call quickui#menu#install('&Debug', [
        \ ["Start &/ Continue\tF5", "call feedkeys('\<F5>')"],
        \ ["&Stop\tF3", "call feedkeys('\<F3>')"],
        \ ["&Restart\tF4", "call feedkeys('\<F4>')"],
        \ ["&Pause\tF6", "call feedkeys('\<F6>')"],
        \ ["R&eset", 'VimspectorReset'],
        \ ["--", ''],
        \ ["&Breakpoint\tF9", "call feedkeys('\<F9>')"],
        \ ["&Conditional Breakpoint\t<leader>F9", "call feedkeys(' \<F9>')"],
        \ ["&Function Breakpoint\tF8", "call feedkeys('\<F8>')"],
        \ ["--", ''],
        \ ["Ru&n To Cursor\t<leader>F8", "call feedkeys(' \<F8>')"],
        \ ["Step &Over\tF10", "call feedkeys('\<F10>')"],
        \ ["Step &Into\tF11", "call feedkeys('\<F11>')"],
        \ ["Step O&ut\tF12", "call feedkeys('\<F12>')"],
        \ ["--", ''],
        \ ["S&how Debug Information\t<leader>di", "call feedkeys(' di')"],
      \ ])
call quickui#menu#install('&Plugin', [
        \ ["&Install Plugins", 'PlugInstall'],
        \ ["&Update Plugins", 'PlugUpdate'],
        \ ["Plugin &Status", 'PlugStatus'],
        \ ["&Remove Unused Plugins", 'source $MYVIMRC | PlugClean'],
        \ ["--", ''],
        \ ["Install &Coc Plugins", 'exec "CocInstall " .. quickui#input#open("Plugin name:")'],
        \ ["U&pdate Coc Plugins", 'CocUpdate'],
        \ ["Lis&t Coc Plugins", 'CocList extensions'],
        \ ["Coc Co&mmands", 'CocList commands'],
        \ ["Coc Plugins Con&fig", 'CocConfig'],
      \ ])
call quickui#menu#install("&Tools", [
        \ ["Code &Snapshot", 'Silicon'],
        \ ["--", ''],
        \ ["Cpp&Insights", 'Insights', 'Run cppinsights'],
        \ ["CppInsights Diff", 'InsightsDiff', 'Run cppinsights and diff with source'],
        \ ["--", ''],
        \ ["&Markdown Preview", 'CocCommand markdown-preview-enhanced.openPreview'],
        \ ["Live &Preview", 'Bracey', 'Launch a live server for HTML/CSS/JAVASCRIPT preview'],
      \ ])
call quickui#menu#install('Help (&?)', [
        \ ["Help\t<leader>h", 'CocList helptags'],
        \ ["--", ''],
        \ ["&Welcome", 'Startify'],
        \ ["&About", "call quickui#textbox#open(g:about_text, {'title': 'About'})"],
      \ ])
let g:context_k = [
        \ ["&Open Path\tgf", "call feedkeys('gf')", 'Open file under the cursor'],
        \ ["Open &URL\tgx", "call feedkeys('gx')", 'Open URL under the cursor in default browser'],
        \ ["--", ''],
        \ ["Goto &Definition\tgd", "call CocActionAsync('jumpDefinition')"],
        \ ["Goto &Type Definition\tgy", "call CocActionAsync('jumpTypeDefinition')"],
        \ ["Goto &Implementation\tgi", "call CocActionAsync('jumpImplementation')"],
        \ ["--", ''],
        \ ["List &References\tgr", "call CocActionAsync('jumpImplementation')"],
        \ ["Show &Hover\tgh", "call CocActionAsync('doHover')", 'Show information for the current symbol'],
        \ ["Re&name\t<leader>rn", "call CocActionAsync('rename')"],
        \ ["Code &Actions\t<leader>a", "call feedkeys(' a')", 'Trigger code actions for the current symbol'],
        \ ["Quick &Fix\t<leader>qf", "call feedkeys(' qf')", 'Execute quick fix for the current line'],
        \ ["--", ''],
        \ ["&Help", "call feedkeys('K', 'in')"],
        \ ["&Cppman", 'exec "Cppman " . expand("<cword>")'],
        \ ["&Pydoc", 'call quickui#tools#python_help(expand("<cword>"))'],
      \ ]

" Fix termguicolors in TMUX
if executable('tmux') && strlen($TMUX)
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
set termguicolors

autocmd ColorScheme * call Highlight()
function! Highlight() abort
    hi CocErrorHighlight cterm=bold ctermfg=Red gui=bold guifg=#EF2F27
    hi CocInlayHint ctermfg=White ctermbg=DarkGrey guifg=#d8d8d8 guibg=#3a3a3a
endfunction

set background=dark
autocmd vimenter * ++nested colorscheme enfocado
