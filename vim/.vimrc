" ============================================================================
" ========================== Basic Settings ==================================
" ============================================================================
let mapleader = ' '
let &t_SI.="\e[6 q"
let &t_SR.="\e[4 q"
let &t_EI.="\e[2 q"
let g:netrw_browsex_viewer = system('echo -n $BROWSER')

set hidden
set number
set relativenumber
set ignorecase
set expandtab
set nowrap
set splitbelow
set splitright
set nowritebackup
set noswapfile
set showcmd
set hlsearch
set nofoldenable
set helpheight=10
set scrolloff=5
set mouse=a
set shell=/bin/bash

inoremap <C-H> <Left>
inoremap <C-J> <Down>
inoremap <C-K> <Up>
inoremap <C-L> <Right>
cnoremap <C-H> <Left>
cnoremap <C-J> <Down>
cnoremap <C-K> <Up>
cnoremap <C-L> <Right>
inoremap <C-S> <ESC>:w<CR>
nnoremap <C-S> <Cmd>w<CR>
nnoremap q <Cmd>q<CR>
nnoremap Q <Cmd>qa!<CR>
nnoremap <C-Q> <Cmd>bd<CR>

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
Plug 'kshenoy/vim-signature'
Plug 'skywind3000/vim-terminal-help'
Plug 'lambdalisue/suda.vim', { 'on': ['SudaRead', 'SudaWrite'] }
Plug 'farmergreg/vim-lastplace'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-sleuth'
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'machakann/vim-highlightedyank'
Plug 'simeji/winresizer', { 'on': 'WinResizerStartResize' }
Plug 'junegunn/vim-peekaboo'
Plug 'rhysd/clever-f.vim'
" |  +--- Text Objects
Plug 'wellle/targets.vim'
Plug 'michaeljsmith/vim-indent-object', { 'for': ['python', 'vim'] }
" +--- Edit Enhancement
Plug 'tpope/vim-rsi'
Plug 'ConradIrwin/vim-bracketed-paste'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'mg979/vim-visual-multi', { 'branch': 'master' }
Plug 'ntpeters/vim-better-whitespace'
Plug 'dhruvasagar/vim-table-mode', { 'on': 'TableModeToggle' }
Plug 'junegunn/vim-easy-align', { 'on': '<Plug>(EasyAlign)' }
Plug 'tommcdo/vim-exchange'
Plug 'sickill/vim-pasta'
Plug 'chrisbra/NrrwRgn', { 'on': 'NR' }
Plug 'brooth/far.vim', { 'on': ['Far', 'F', 'Farr', 'Farf'] }
Plug 'rhysd/vim-grammarous', { 'on': 'GrammarousCheck' }
" +--+ Beautify
Plug 'mhinz/vim-startify'
Plug 'vim-airline/vim-airline'
Plug 'lambdalisue/glyph-palette.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'skywind3000/vim-quickui'
" |  +--- Theme
Plug 'vim-airline/vim-airline-themes'
Plug 'wuelnerdotexe/vim-enfocado'
Plug 'srcery-colors/srcery-vim'
Plug 'NLKNguyen/papercolor-theme'
Plug 'bluz71/vim-moonfly-colors'
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
Plug 'tpope/vim-endwise', { 'for': ['fish', 'lua', 'ruby', 'vim'] }
"    +--- Git
Plug 'tpope/vim-fugitive', { 'on': ['Git', 'Gvdiffsplit', 'Gvsplit'] }
"    +--- C/C++
Plug 'skywind3000/vim-cppman', { 'on': 'Cppman' }
"    +--- HTML/CSS/JavaScript
Plug 'alvan/vim-closetag', { 'for': ['html', 'xml'] }
Plug 'ap/vim-css-color'
Plug 'turbio/bracey.vim', { 'do': 'npm install --prefix server', 'on': 'Bracey' }
"    +--- markdown
Plug 'preservim/vim-markdown'
Plug 'preservim/vim-pencil', { 'for': 'markdown' }
"    +--- SQL
Plug 'tpope/vim-dadbod', { 'on': 'DBUIToggle' }
Plug 'kristijanhusak/vim-dadbod-ui', { 'on': 'DBUIToggle' }
call plug#end()

" vim-airline
set noshowmode
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0

" indentLine
let g:indentLine_bufTypeExclude = ['help', 'terminal']
let g:indentLine_bufNameExclude = ['/dev/.*', 'man.*', '\[Grammarous\]']
let g:indentLine_fileTypeExclude = ['startify', 'coc-explorer', 'dbui', 'dbout']

" coc.nvim
let g:airline#extensions#coc#error_symbol = ' '
let g:airline#extensions#coc#warning_symbol = '⚠ '
let g:airline#extensions#coc#show_coc_status = 0
set updatetime=100
set shortmess+=c
set signcolumn=yes
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
    \: "\<C-G>u\<CR>\<C-R>=coc#on_enter()\<CR>"
nnoremap <silent> [g <Plug>(coc-diagnostic-prev)
nnoremap <silent> ]g <Plug>(coc-diagnostic-next)
nnoremap <silent> gd <Plug>(coc-definition)
nnoremap <silent> gy <Plug>(coc-type-definition)
nnoremap <silent> gi <Plug>(coc-implementation)
nnoremap <silent> gr <Plug>(coc-references-used)
nnoremap <silent> gh <Cmd>call CocActionAsync('doHover')<CR>
nnoremap <silent> <Leader>rn <Plug>(coc-rename)
nnoremap <silent> <Leader>qf  <Plug>(coc-fix-current)
xnoremap if <Plug>(coc-funcobj-i)
onoremap if <Plug>(coc-funcobj-i)
xnoremap af <Plug>(coc-funcobj-a)
onoremap af <Plug>(coc-funcobj-a)
xnoremap ic <Plug>(coc-classobj-i)
onoremap ic <Plug>(coc-classobj-i)
xnoremap ac <Plug>(coc-classobj-a)
onoremap ac <Plug>(coc-classobj-a)
nnoremap <silent><nowait><expr> <C-J> coc#float#has_scroll() ? coc#float#scroll(1) : "\<Down>"
nnoremap <silent><nowait><expr> <C-K> coc#float#has_scroll() ? coc#float#scroll(0) : "\<Up>"
inoremap <silent><nowait><expr> <C-J> coc#pum#visible() ? coc#pum#next(1) :
    \ coc#float#has_scroll() ? "\<C-R>=coc#float#scroll(1)\<CR>" : "\<Down>"
inoremap <silent><nowait><expr> <C-K> coc#pum#visible() ? coc#pum#prev(1) :
    \ coc#float#has_scroll() ? "\<C-R>=coc#float#scroll(0)\<CR>" : "\<Up>"
nnoremap <silent><nowait> <Leader>o  :call ToggleOutline()<CR>
function! ToggleOutline() abort
    let winid = coc#window#find('cocViewId', 'OUTLINE')
    if winid == -1
        call CocActionAsync('showOutline', 1)
    else
        call coc#window#close(winid)
    endif
endfunction
autocmd CursorHold * silent call CocActionAsync('highlight')
autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
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

" coc-snippets
inoremap <silent><expr> <TAB>
    \ coc#pum#visible() ? coc#_select_confirm() :
    \ coc#expandableOrJumpable() ? "\<C-R>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
    \ CheckBackspace() ? "\<TAB>" :
    \ coc#refresh()
function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
endfunction
let g:coc_snippet_prev = '<S-TAB>'
let g:coc_snippet_next = '<TAB>'

" coc-lists
nnoremap <silent> <Leader>h <Cmd>CocList helptags<CR>

" coc-explorer
nnoremap <silent> <Leader>e <Cmd>CocCommand explorer<CR>

" coc-typos
nmap ]s <Plug>(coc-typos-next)
nmap [s <Plug>(coc-typos-prev)
nmap z= <Plug>(coc-typos-fix)

" vim-terminal-help
let g:terminal_cwd = 2
let g:terminal_kill = 1

" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nnoremap <silent> <Leader>di <Plug>VimspectorBalloonEval
xnoremap <silent> <Leader>di <Plug>VimspectorBalloonEval

" asynctasks.vim
let g:asyncrun_open = 6
let g:asynctasks_term_reuse = 1
let g:asynctasks_term_pos = 'termhelp'
noremap <silent> <Leader>fb <Cmd>AsyncTask file-build<CR>
noremap <silent> <Leader>fr <Cmd>AsyncTask file-run<CR>
noremap <silent> <Leader>pf <Cmd>AsyncTask project-configure<CR>
noremap <silent> <Leader>pb <Cmd>AsyncTask project-build<CR>
noremap <silent> <Leader>pr <Cmd>AsyncTask project-run<CR>

" vim-easymotion
let g:EasyMotion_verbose = 0
noremap <Leader> <Plug>(easymotion-prefix)

" vim-better-whitespace
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
nnoremap <Space><Space> <Cmd>call quickui#menu#open()<CR>
nnoremap <RightMouse> <Cmd>call quickui#context#open(g:context_k, {})<CR>
nnoremap K <Cmd>call CleverK()<CR>
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
nnoremap <silent> <Leader>u <Cmd>UndotreeToggle<CR>

" vim-enfocado
let g:enfocado_plugins = [
    \ 'coc',
    \ 'glyph-palette',
    \ 'matchup',
    \ 'plug',
    \ 'signify',
    \ 'startify',
    \ 'visual-multi',
  \ ]

" vim-easy-align
vnoremap <Enter> <Plug>(EasyAlign)
nnoremap ga <Plug>(EasyAlign)

" vim-template
let g:username = system('git config user.name')[:-2]
let g:email = system('git config user.email')[:-2]
let g:templates_no_builtin_templates = 1
let g:templates_directory = '$HOME/.dotfiles/vim/templates/code'

" vim-doge
let g:doge_enable_mappings = 0

" vim-grammarous
let g:grammarous#show_first_error = 1
let g:grammarous#default_comments_only_filetypes = {
        \ '*' : 1, 'help' : 0, 'markdown' : 0,
    \ }
let g:grammarous#languagetool_cmd = 'languagetool'

" papercolor-theme
let g:PaperColor_Theme_Options = {
  \     'language': {
  \         'python': {
  \             'highlight_builtins' : 1
  \         },
  \         'cpp': {
  \             'highlight_standard_library': 1
  \         },
  \         'c': {
  \             'highlight_builtins' : 1
  \         }
  \     }
  \ }

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" context.vim
let g:context_filetype_blacklist = ['coc-explorer', 'coctree', 'undotree', 'help']

" clever-f.vim
noremap ; <Plug>(clever-f-repeat-forward)
noremap , <Plug>(clever-f-repeat-back)

" far.vim
let g:far#enable_undo = 1

" vim-dadbod-ui
let g:db_ui_show_database_icon = 1
let g:db_ui_use_nerd_fonts = 1

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
        \ ["&Save\t<C-S>", 'w'],
        \ ["Save &All", 'wa'],
        \ ["Sudo Save", 'SudaWrite', 'Write files with SUDO privilege'],
        \ ["--", ''],
        \ ["&Exit\tQ", 'qa!'],
    \ ])
call quickui#menu#install('&Edit', [
        \ ["&Strip Trailing", 'StripWhitespace'],
        \ ["--", ''],
        \ ["&Generate Template", 'Template', 'Generate template codes for current filetype'],
        \ ["Generate &Markdown TOC", 'CocCommand markdown-preview-enhanced.insertTOC', 'Generate TOC under the current cursor'],
        \ ["--", ''],
        \ ["&Table Mode", 'TableModeToggle', 'A fancy mode for creating tables'],
        \ ["--", ''],
        \ ["&Format Codes", "call feedkeys('\<Plug>(coc-format)')"],
    \ ])
call quickui#menu#install('&View', [
        \ ["Switch &Buffer", "call quickui#tools#list_buffer('e')"],
        \ ["&Resize Windows", 'WinResizerStartResize', 'A fancy mode for easy resizing windows'],
        \ ["--", ''],
        \ ["&Explorer\t<Leader>e", 'CocCommand explorer', 'Open file explorer'],
        \ ["&Terminal\t<M-=>", "call feedkeys('\<m-=>')"],
        \ ["&Outline\t<Leader>o", 'call ToggleOutline()', 'Open symbols outline tree'],
        \ ["&Undotree\t<Leader>u", 'UndotreeToggle', 'Open undo history'],
        \ ["--", ''],
        \ ["Data&base Dashboard", 'DBUIToggle'],
        \ ["Markdown TO&C", 'Toc'],
    \ ])
call quickui#menu#install('&Navigation', [
        \ ["&Find", 'Farf'],
        \ ["Find And Re&place", 'Farr'],
        \ ["--", ''],
        \ ["Goto &Definition\tgd", "call feedkeys('\<Plug>(coc-definition)')"],
        \ ["Goto &Type Definition\tgy", "call feedkeys('\<Plug>(coc-type-definition)')"],
        \ ["Goto &Implementation\tgi", "call feedkeys('\<Plug>(coc-implementation)')"],
        \ ["&References\tgr", "call feedkeys('\<Plug>(coc-references-used)')"],
    \ ])
call quickui#menu#install('&Git', [
        \ ["Git &Status", 'Git'],
        \ ["Git &Diff", 'Gvdiffsplit'],
        \ ["--", ''],
        \ ["Git &Edit", "call feedkeys(':Gvsplit ')", 'View any blob, tree, commit, or tag in the repository'],
    \ ])
call quickui#menu#install('&Build', [
        \ ["Browse &Tasks", 'CocList tasks'],
        \ ["--", ''],
        \ ["File &Compile\t<Leader>fb", 'AsyncTask file-build'],
        \ ["File &Execute\t<Leader>fr", 'AsyncTask file-run'],
        \ ["--", ''],
        \ ["Project Con&figure\t<Leader>pf", 'AsyncTask project-configure'],
        \ ["Project &Build\t<Leader>pb", 'AsyncTask project-build'],
        \ ["Project &Run\t<Leader>pr", 'AsyncTask project-run'],
        \ ["Project Clea&n", 'AsyncTask project-clean']
    \ ])
call quickui#menu#install('&Debug', [
        \ ["Start &/ Continue\tF5", "call feedkeys('\<Plug>VimspectorContinue')"],
        \ ["&Stop\tF3", "call feedkeys('\<Plug>VimspectorStop')"],
        \ ["&Restart\tF4", "call feedkeys('\<Plug>VimspectorRestart')"],
        \ ["&Pause\tF6", "call feedkeys('\<Plug>VimspectorPause')"],
        \ ["R&eset", 'VimspectorReset'],
        \ ["--", ''],
        \ ["&Breakpoint\tF9", "call feedkeys('\<Plug>VimspectorToggleBreakpoint')"],
        \ ["&Conditional Breakpoint\t<Leader>F9", "call feedkeys('\<Plug>VimspectorToggleConditionalBreakpoint')"],
        \ ["&Function Breakpoint\tF8", "call feedkeys('\<Plug>VimspectorAddFunctionBreakpoint')"],
        \ ["--", ''],
        \ ["Ru&n To Cursor\t<Leader>F8", "call feedkeys('\<Plug>VimspectorRunToCursor')"],
        \ ["Step &Over\tF10", "call feedkeys('\<Plug>VimspectorStepOver')"],
        \ ["Step &Into\tF11", "call feedkeys('\<Plug>VimspectorStepInto')"],
        \ ["Step O&ut\tF12", "call feedkeys('\<Plug>VimspectorStepOut')"],
        \ ["--", ''],
        \ ["S&how Debug Information\t<Leader>di", "call feedkeys('\<Plug>VimspectorBalloonEval')"],
    \ ])
call quickui#menu#install('&Plugin', [
        \ ["&Install Plugins", 'PlugInstall'],
        \ ["&Update Plugins", 'PlugUpdate'],
        \ ["Plugin &Status", 'PlugStatus'],
        \ ["&Remove Unused Plugins", 'PlugClean'],
        \ ["--", ''],
        \ ["U&pdate Coc Plugins", 'CocUpdate'],
        \ ["Lis&t Coc Plugins", 'CocList extensions'],
        \ ["Coc Plugins' Con&fig", 'CocConfig'],
        \ ["--", ''],
        \ ["Coc Co&mmands", 'CocList commands'],
    \ ])
call quickui#menu#install("&Tools", [
        \ ["&Diff Modification", 'vert new | set bt=nofile | r ++edit # | 0d_ | diffthis | wincmd p | diffthis'],
        \ ["Code &Snapshot", 'Silicon'],
        \ ["--", ''],
        \ ["&Grammar Check", 'GrammarousCheck'],
        \ ["&Typos Check", 'CocList typos'],
        \ ["--", ''],
        \ ["&Markdown Preview", 'CocCommand markdown-preview-enhanced.openPreview'],
        \ ["Live &Preview", 'Bracey', 'Launch a live server for HTML/CSS/JAVASCRIPT preview'],
    \ ])
call quickui#menu#install('Help (&?)', [
        \ ["Help\t<Leader>h", 'CocList helptags'],
        \ ["Display &Messages", 'call quickui#tools#display_messages()'],
        \ ["--", ''],
        \ ["&Welcome", 'Startify'],
        \ ["&About", "call quickui#textbox#open(g:about_text, {'title': 'About'})"],
    \ ])
let g:context_k = [
        \ ["H&over\tgh", "call CocActionAsync('doHover')"],
        \ ["--", ''],
        \ ["Re&name\t<Leader>rn", "call feedkeys('\<Plug>(coc-rename)')"],
        \ ["Quick &Fix\t<Leader>qf", "call feedkeys('\<Plug>(coc-fix-current)')", 'Execute quick fix for the current line'],
        \ ["Code &Actions", "call feedkeys('\<Plug>(coc-codeaction-cursor)')", 'Trigger code actions for the current symbol'],
        \ ["--", ''],
        \ ["Do&ge Here", 'DogeGenerate', 'Generate document comments for current symbol'],
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
    hi CocErrorHighlight cterm=bold ctermfg=Red ctermbg=NONE gui=bold guifg=#EF2F27 guibg=NONE
    hi CocErrorSign cterm=bold ctermfg=Red ctermbg=NONE gui=bold guifg=#EF2F27 guibg=NONE
    hi CocInlayHint ctermfg=White ctermbg=DarkGrey guifg=#d8d8d8 guibg=#3a3a3a
endfunction

set background=dark
autocmd VimEnter * ++nested colorscheme srcery
