" ============================================================
" http://zsaber.com/blog/p/31
" ============================================================

if 1 " global settings
    " env
    let g:zf_windows=0
    if(has('win32') || has('win64') || has('win95') || has('win16'))
        let g:zf_windows=1
    endif
    let g:zf_mac=0
    if(has('unix'))
        try
            silent! let s:uname=system('uname')
            if match(s:uname, 'Darwin') >= 0
                let g:zf_mac=1
            endif
        endtry
    endif
    let g:zf_linux=0
    if(has('unix'))
        let g:zf_linux=1
    endif
    if g:zf_windows!=1 && g:zf_mac!=1
        let g:zf_linux=1
    elseif g:zf_linux==1
        let g:zf_windows=0
    endif

    if !exists('g:zf_fakevim')
        let g:zf_fakevim=0
    endif

    if !exists('g:zf_no_plugin')
        let g:zf_no_plugin=g:zf_fakevim
    endif

    " leader should be set before other key map
    if g:zf_fakevim!=1
        let mapleader="'"
    else
        let mapleader='\'
        map ' <leader>
    endif

    " global ignore
    let g:zf_exclude_common = []
    let g:zf_exclude_common += [ 'tags' , '.vim_tags' ]
    let g:zf_exclude_common += [ '*.swp' ]
    let g:zf_exclude_common += [ '.DS_Store' ]
    let g:zf_exclude_common += [ '*.d' , '*.depend*' ]
    let g:zf_exclude_common += [ '*.a' , '*.o' , '*.so' , '*.dylib' ]
    let g:zf_exclude_common += [ '*.jar' , '*.class' ]
    let g:zf_exclude_common += [ '*.exe' , '*.dll' ]
    let g:zf_exclude_common += [ '*.iml' , 'local.properties' ]
    let g:zf_exclude_common += [ '*.user' ]

    let g:zf_exclude_common_dir = []
    let g:zf_exclude_common_dir += [ '.svn' , '.git' , '.hg' ]
    let g:zf_exclude_common_dir += [ '.cache' , '_cache' ]
    let g:zf_exclude_common_dir += [ '.tmp' , '_tmp' ]
    let g:zf_exclude_common_dir += [ '.release' , '_release' ]
    let g:zf_exclude_common_dir += [ '.build' , '_build' ]
    let g:zf_exclude_common_dir += [ 'build-*' ]
    let g:zf_exclude_common_dir += [ '_repo' ]
    let g:zf_exclude_common_dir += [ '.idea' , '.gradle' ]
    let g:zf_exclude_common_dir += [ 'build' , '.externalNativeBuild' ]

    let g:zf_exclude_media = []
    let g:zf_exclude_media += [ '*.ico' , '*.jpg' , '*.jpeg' , '*.png' , '*.bmp' , '*.gif' , '*.webp' , '*.icns' ]
    let g:zf_exclude_media += [ '*.mp2' , '*.mp3' , '*.wav' , '*.ogg' ]

    function! ZF_ExcludeExpandDir(pattern, ...)
        let pattern = a:pattern
        let token = get(a:000, 0, '*')
        let ret = []
        for item in pattern
            call add(ret, item)
            if empty(matchstr(item, '^/'))
                call add(ret, token . '/' . item . '/' . token)
            else
                call add(ret, item . '/' . token)
            endif
        endfor
        return ret
    endfunction
    function! s:ZF_ExcludeInit()
        let g:zf_exclude_all_file = []
        let g:zf_exclude_all_file += g:zf_exclude_common
        let g:zf_exclude_all_file += g:zf_exclude_media

        let g:zf_exclude_all_dir = []
        let g:zf_exclude_all_dir += g:zf_exclude_common_dir

        let g:zf_exclude_all = []
        let g:zf_exclude_all += g:zf_exclude_all_file
        let g:zf_exclude_all += g:zf_exclude_all_dir

        let g:zf_exclude_all_expand = []
        let g:zf_exclude_all_expand += g:zf_exclude_all_file
        let g:zf_exclude_all_expand += ZF_ExcludeExpandDir(g:zf_exclude_all_dir)
    endfunction
    call s:ZF_ExcludeInit()

    function! ZF_ExcludeAdd(pattern, ...)
        let name = 'g:zf_exclude_' . get(a:000, 0, 'common_dir')
        let needNotify = get(a:000, 1, 1)
        silent! execute 'let ' . name . ' += ["' . a:pattern . '"]'
        call s:ZF_ExcludeInit()
        if needNotify
            doautocmd User ZFExcludeChanged
        endif
        echo 'exclude pattern added: ' . a:pattern
    endfunction
    " ZFExcludeAdd pattern [excludeGroupName] [needNotify]
    command! -nargs=+ -complete=file ZFExcludeAdd :call ZF_ExcludeAdd(<f-args>)

    " git info
    if !exists('g:zf_git_user_email')
        let g:zf_git_user_email = 'z@zsaber.com'
    endif
    if !exists('g:zf_git_user_name')
        let g:zf_git_user_name = 'ZSaberLv0'
    endif
    function! ZF_GitGlobalConfig()
        call system('git config --global user.email "' . g:zf_git_user_email . '"')
        call system('git config --global user.name "' . g:zf_git_user_name . '"')
        call system('git config push.default "simple"')
        echo 'git global user changed to ' . g:zf_git_user_name . ' <' . g:zf_git_user_email . '>'
    endfunction
    command! -nargs=0 ZFGitGlobalConfig :call ZF_GitGlobalConfig()
endif " global settings


" ============================================================
" all plugins
"     vim-plug
"     git clone --depth=1 --single-branch https://github.com/ZSaberLv0/vim-plug $HOME/.vim/bundle/vim-plug
if g:zf_no_plugin!=1
    source $HOME/.vim/bundle/vim-plug/plug.vim
    let g:plug_url_format='https://github.com/%s'
    let g:plug_home=$HOME . '/.vim/bundle'
    call plug#begin()
    " Plug 'junegunn/vim-plug'
    Plug 'ZSaberLv0/vim-plug'

    " ==================================================
    if 1 " themes
        " ==================================================
        " let g:zf_color_plugin_(256|default)='YourSchemePlugin'
        " let g:zf_color_name_(256|default)='YourSchemeName'
        " let g:zf_color_bg_(256|default)='dark_or_light'
        if !exists('g:zf_color_plugin_default')
            let g:zf_color_plugin_default='vim-scripts/xterm16.vim'
        endif
        if !exists('g:zf_color_name_default')
            let g:zf_color_name_default='xterm16'
        endif
        if !exists('g:zf_color_bg_default')
            let g:zf_color_bg_default='dark'
        endif

        if !empty('g:zf_color_plugin_default')
            Plug g:zf_color_plugin_default
            let xterm16_brightness='high'
            let xterm16_colormap='soft'
        endif

        " ==================================================
        if !exists('g:zf_color_plugin_256')
            let g:zf_color_plugin_256='tomasr/molokai'
        endif
        if !exists('g:zf_color_name_256')
            let g:zf_color_name_256='molokai'
        endif
        if !exists('g:zf_color_bg_256')
            let g:zf_color_bg_256=g:zf_color_bg_default
        endif

        if !exists('g:zf_colorscheme_256')
            let g:zf_colorscheme_256 = 0
        elseif g:zf_colorscheme_256 == 1
            set t_Co=256
        endif
        if g:zf_color_plugin_256 != '' && g:zf_color_plugin_256 != g:zf_color_plugin_default
            Plug g:zf_color_plugin_256
        endif
    endif " themes

    " ==================================================
    if 1 " common plugins for happy text editing
        " ==================================================
        if !exists('g:ZF_Plugin_agit')
            let g:ZF_Plugin_agit=1
        endif
        if g:ZF_Plugin_agit==1
            Plug 'cohama/agit.vim'
            let g:agit_no_default_mappings=1
            let g:agit_ignore_spaces=0
            function! ZF_Plugin_agit_print_commitmsg()
                try
                    execute "normal \<Plug>(agit-print-commitmsg)"
                endtry
            endfunction
            function! ZF_Plugin_agit_diff()
                silent! execute "normal \<Plug>(agit-diff)"
            endfunction
            function! ZF_Plugin_agit_diff_with_local()
                silent! execute "normal \<Plug>(agit-diff-with-local)"
            endfunction
            augroup ZF_Plugin_agit_augroup
                autocmd!
                autocmd FileType agit,agit_stat,agit_diff
                            \ nmap <silent><buffer> q <Plug>(agit-exit)|
                            \ nmap <silent><buffer> p :call ZF_Plugin_agit_print_commitmsg()<cr>|
                            \ nmap <silent><buffer> DI :call ZF_Plugin_agit_diff()<cr>|
                            \ nmap <silent><buffer> DL :call ZF_Plugin_agit_diff_with_local()<cr>
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_asyncrun')
            let g:ZF_Plugin_asyncrun=1
        endif
        if g:ZF_Plugin_asyncrun==1
            Plug 'skywind3000/asyncrun.vim'
        endif
        nnoremap <leader>va :AsyncRun<space>
        let g:asyncrun_exit='echo "AsyncRun " . g:asyncrun_status . "(" . g:asyncrun_code'
                    \ . ' . "), use `:copen` to see the result"'
        " ==================================================
        if !exists('g:ZF_Plugin_auto_mkdir')
            let g:ZF_Plugin_auto_mkdir=1
        endif
        if g:ZF_Plugin_auto_mkdir==1
            Plug 'DataWraith/auto_mkdir'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_auto_pairs')
            let g:ZF_Plugin_auto_pairs=1
        endif
        if g:ZF_Plugin_auto_pairs==1
            Plug 'jiangmiao/auto-pairs'
            let g:AutoPairsShortcurToggle=''
            let g:AutoPairsShortcutFastWrap=''
            let g:AutoPairsShortcutJump=''
            let g:AutoPairsShortcutBackInsert=''
            let g:AutoPairsCenterLine=0
            let g:AutoPairsMultilineClose=0
            let g:AutoPairsMapBS=1
            let g:AutoPairsMapCh=0
            let g:AutoPairsMapCR=0
            let g:AutoPairsCenterLine=0
            let g:AutoPairsMapSpace=0
            let g:AutoPairsFlyMode=0
            let g:AutoPairsMultilineClose=0
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_BufOnly')
            let g:ZF_Plugin_BufOnly=1
        endif
        if g:ZF_Plugin_BufOnly==1
            Plug 'vim-scripts/BufOnly.vim'
            nnoremap X :BufOnly<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_buftabline')
            let g:ZF_Plugin_buftabline=1
        endif
        if g:ZF_Plugin_buftabline==1
            Plug 'ap/vim-buftabline'
            let g:buftabline_numbers=1
            let g:buftabline_indicators=1
            augroup ZF_Plugin_buftabline_augroup
                autocmd!
                autocmd User ZFVimrcPost
                            \ highlight link BufTabLineCurrent ZFColor_TabActive|
                            \ highlight link BufTabLineActive ZFColor_TabInactive|
                            \ highlight link BufTabLineHidden ZFColor_TabInactive|
                            \ highlight link BufTabLineFill ZFColor_TabInactive
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_clever_f')
            let g:ZF_Plugin_clever_f=1
        endif
        if g:ZF_Plugin_clever_f==1
            Plug 'rhysd/clever-f.vim'
            let g:clever_f_not_overwrites_standard_mappings=1
            nmap f <Plug>(clever-f-f)
            xmap f <Plug>(clever-f-f)
            omap f <Plug>(clever-f-f)
            nmap F <Plug>(clever-f-F)
            xmap F <Plug>(clever-f-F)
            omap F <Plug>(clever-f-F)
            let g:clever_f_across_no_line=1
            let g:clever_f_smart_case=1
            let g:clever_f_fix_key_direction=1
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_CmdlineComplete')
            let g:ZF_Plugin_CmdlineComplete=1
        endif
        if g:ZF_Plugin_CmdlineComplete==1
            Plug 'vim-scripts/CmdlineComplete'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_dirdiff')
            let g:ZF_Plugin_dirdiff=1
        endif
        if g:ZF_Plugin_dirdiff==1
            Plug 'will133/vim-dirdiff'
            let g:DirDiffEnableMappings=0
            function! ZF_Plugin_dirdiff_updateIgnore()
                let tmp = []
                let tmp += g:zf_exclude_common
                let tmp += ZF_ExcludeExpandDir(g:zf_exclude_common_dir)
                let g:DirDiffExcludes = join(tmp, ',')
            endfunction
            call ZF_Plugin_dirdiff_updateIgnore()
            augroup ZF_Plugin_dirdiff_augroup
                autocmd!
                autocmd User ZFExcludeChanged call ZF_Plugin_dirdiff_updateIgnore()
            augroup END
            let g:DirDiffWindowSize=15
            let g:DirDiffIgnoreCase=0
            let g:DirDiffForceLang=''
            function! ZF_Plugin_DirDiff_action(arg)
                execute ':DirDiff ' . a:arg
            endfunction
            command! -nargs=+ -complete=dir ZFDiffDir :call ZF_Plugin_DirDiff_action(<q-args>)
            nnoremap <leader>vdd :ZFDiffDir<space>

            function! ZF_DiffGit(repo)
                redraw!
                echo 'updating ' . a:repo . ' ...'
                let tmp_path = $HOME . '/.vim_cache/_zf_diffgit_tmp_'
                let dummy = system('rm -rf "' . tmp_path . '"')
                let dummy = system('git clone ' . a:repo . ' "' . tmp_path . '"')
                execute ':ZFDiffDir ' . tmp_path . ' .'
                augroup ZF_DiffGit_autoclean_augroup
                    autocmd!
                    autocmd VimLeavePre * call system('rm -rf "' . $HOME . '/.vim_cache/_zf_diffgit_tmp_"')
                augroup END
            endfunction
            command! -nargs=+ ZFDiffGit :call ZF_DiffGit(<q-args>)
            function! ZF_DiffGitGetParam()
                return 'https://github.com/' . g:zf_git_user_name . '/' . fnamemodify(getcwd(), ':t')
            endfunction
            nnoremap <leader>vdg :ZFDiffGit <c-r>=ZF_DiffGitGetParam()<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_easy_align')
            let g:ZF_Plugin_easy_align=1
        endif
        if g:ZF_Plugin_easy_align==1
            Plug 'junegunn/vim-easy-align'
            let g:easy_align_ignore_groups=[]
            function! ZF_Plugin_EasyAlign_regexFix(param)
                let param = substitute(a:param, '/', '_zf_slash_', 'g')
                let param = substitute(a:param, '\\\\', '_zf_bslash_', 'g')
                let head = matchstr(a:param, '^[^/]*/')
                let tail = matchstr(a:param, '/[^/]*$')
                if empty(head) || empty(tail)
                    return a:param
                endif
                let regexp = strpart(param, len(head), len(param) - len(head) - len(tail))
                let regexp = substitute(regexp, '^\\v', '', 'g')
                try
                    let regexp = E2v(regexp)
                catch
                    return a:param
                endtry
                let param = head . regexp . tail
                let param = substitute(param, '_zf_slash_', '/', 'g')
                let param = substitute(param, '_zf_bslash_', '\\\\', 'g')
                return param
            endfunction
            command! -nargs=* -range -bang ZFEasyAlign execute '<line1>,<line2>EasyAlign' ZF_Plugin_EasyAlign_regexFix(<q-args>)
            xmap <leader>ca :ZFEasyAlign /\v/<left>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_easygrep')
            let g:ZF_Plugin_easygrep=1
        endif
        if g:ZF_Plugin_easygrep==1
            set grepprg=grep\ -n\ $*\ /dev/null
            Plug 'dkprice/vim-easygrep'
            let g:EasyGrepRecursive=1
            let g:EasyGrepAllOptionsInExplorer=1
            let g:EasyGrepCommand=1
            let g:EasyGrepPerlStyle=1
            function! ZF_Plugin_easygrep_updateIgnore()
                let g:EasyGrepFilesToExclude = join(g:zf_exclude_all_expand, ',')
            endfunction
            call ZF_Plugin_easygrep_updateIgnore()
            augroup ZF_Plugin_easygrep_augroup
                autocmd!
                autocmd User ZFExcludeChanged call ZF_Plugin_easygrep_updateIgnore()
            augroup END
            let g:EasyGrepReplaceWindowMode=2
            let g:EasyGrepDisableCmdParam=1

            if 1 " ulgy workaround to prevent default keymap
                let g:EasyGrepOptionPrefix='<leader>v?grep?y'
                map <silent> <leader>v?grep?v <plug>EgMapGrepCurrentWord_v
                xmap <silent> <leader>v?grep?v <plug>EgMapGrepSelection_v
                map <silent> <leader>v?grep?V <plug>EgMapGrepCurrentWord_V
                xmap <silent> <leader>v?grep?V <plug>EgMapGrepSelection_V
                map <silent> <leader>v?grep?a <plug>EgMapGrepCurrentWord_a
                xmap <silent> <leader>v?grep?a <plug>EgMapGrepSelection_a
                map <silent> <leader>v?grep?A <plug>EgMapGrepCurrentWord_A
                xmap <silent> <leader>v?grep?A <plug>EgMapGrepSelection_A
                map <silent> <leader>v?grep?r <plug>EgMapReplaceCurrentWord_r
                xmap <silent> <leader>v?grep?r <plug>EgMapReplaceSelection_r
                map <silent> <leader>v?grep?R <plug>EgMapReplaceCurrentWord_R
                xmap <silent> <leader>v?grep?R <plug>EgMapReplaceSelection_R
            endif

            function! ZF_Plugin_easygrep_Grep(arg)
                execute ':Grep ' . a:arg
                execute ':silent! M/' . a:arg
            endfunction
            command! -nargs=+ ZFGrep :call ZF_Plugin_easygrep_Grep(<q-args>)
            nnoremap <leader>vgf :ZFGrep<space>
            nnoremap <leader>vgr :Replace //<left>
            nmap <leader>vgo <plug>EgMapGrepOptions
            let s:ZF_Plugin_easygrep_toggle_ignore_on=0
            let s:ZF_Plugin_easygrep_toggle_ignore_saved_wildignore=''
            let s:ZF_Plugin_easygrep_toggle_ignore_saved_easygrepignore=''
            function! ZF_Plugin_easygrep_toggle_ignore()
                let s:ZF_Plugin_easygrep_toggle_ignore_on=1-s:ZF_Plugin_easygrep_toggle_ignore_on
                if s:ZF_Plugin_easygrep_toggle_ignore_on==1
                    let s:ZF_Plugin_easygrep_toggle_ignore_saved_wildignore=&wildignore
                    let s:ZF_Plugin_easygrep_toggle_ignore_saved_easygrepignore=g:EasyGrepFilesToExclude
                    set wildignore=
                    let g:EasyGrepFilesToExclude=''
                    echo 'easygrep global ignore off'
                else
                    let &wildignore=s:ZF_Plugin_easygrep_toggle_ignore_saved_wildignore
                    let g:EasyGrepFilesToExclude=s:ZF_Plugin_easygrep_toggle_ignore_saved_easygrepignore
                    echo 'easygrep global ignore on'
                endif
            endfunction
            nnoremap <leader>vgi :call ZF_Plugin_easygrep_toggle_ignore()<cr>

            function! ZF_Plugin_easygrep_pcregrep(expr)
                let expr = a:expr
                let expr = substitute(expr, '"', '\\"', 'g')

                let cmd = 'pcregrep --buffer-size=16M -M -r -s -n'
                if match(expr, '\C[A-Z]') < 0
                    let cmd .= ' -i'
                endif
                let ignoreList = split(g:EasyGrepFilesToExclude, ',')
                for ignore in ignoreList
                    let ignore = substitute(ignore, '\.', '\\.', 'g')
                    let ignore = substitute(ignore, '\*', '.*', 'g')

                    let cmd .= ' --exclude-dir="' . ignore . '"'
                    let cmd .= ' --exclude="' . ignore . '"'
                endfor
                let cmd .= ' "' . expr . '" *'

                let result = system(cmd)
                let qflist = []
                let vim_pattern = E2v(a:expr)
                for line in split(result, '\n')
                    let file = substitute(matchstr(line, '^[^:]\+:'), ':', '', 'g')
                    let file_line = substitute(matchstr(line, ':[0-9]\+:'), ':', '', 'g')
                    if strlen(file) <= 0 || strlen(file_line) <= 0
                        continue
                    endif
                    let text = substitute(line, '^\[^:\]*:\[^:\]*:\(.*\)$', '\1', 'g')
                    let qflist += [{
                                \ 'filename' : file,
                                \ 'lnum' : file_line,
                                \ 'text' : text,
                                \ 'pattern' : vim_pattern,
                                \ }]
                endfor
                call setqflist(qflist)
                if len(qflist) > 0
                    execute ':silent! M/' . a:expr
                    copen
                else
                    echo 'no matches for: ' . a:expr
                endif
            endfunction
            command! -nargs=+ ZFGrepExt :call ZF_Plugin_easygrep_pcregrep(<q-args>)
            try
                if match(system('pcregrep --version'), '[0-9]\+\.[0-9]\+') < 0
                    nnoremap <leader>vge :echo 'pcregrep not installed'<cr>
                else
                    nnoremap <leader>vge :ZFGrepExt<space>
                endif
            endtry
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_easymotion')
            let g:ZF_Plugin_easymotion=1
        endif
        if g:ZF_Plugin_easymotion==1
            Plug 'easymotion/vim-easymotion'
            let g:EasyMotion_do_mapping=0
            let g:EasyMotion_smartcase=1
            let g:EasyMotion_use_upper=1
            let g:EasyMotion_keys='ASDGHKLQWERTYUIOPZXCVBNMFJ'
            nmap s <plug>(easymotion-s)
            xmap s <plug>(easymotion-s)
            omap s <plug>(easymotion-s)
            nmap S <plug>(easymotion-sol-bd-jk)
            xmap S <plug>(easymotion-sol-bd-jk)
            omap S <plug>(easymotion-sol-bd-jk)
            augroup ZF_Plugin_easymotion_augroup
                autocmd!
                autocmd User ZFVimrcPost
                            \ highlight EasyMotionTarget guibg=NONE guifg=White|
                            \ highlight EasyMotionTarget ctermbg=NONE ctermfg=White|
                            \ highlight link EasyMotionTarget2First EasyMotionTarget|
                            \ highlight link EasyMotionTarget2Second EasyMotionTarget|
                            \ highlight EasyMotionShade guibg=NONE guifg=DarkRed|
                            \ highlight EasyMotionShade ctermbg=NONE ctermfg=DarkRed|
                            \ highlight link EasyMotionIncSearch EasyMotionShade|
                            \ highlight link EasyMotionMoveHL EasyMotionShade
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_eregex')
            let g:ZF_Plugin_eregex=1
        endif
        if g:ZF_Plugin_eregex==1
            Plug 'othree/eregex.vim'
            let g:eregex_default_enable=0
            function! ZF_Plugin_eregex_sort(bang, line1, line2, args)
                let cmd = a:line1 . ',' . a:line2 . 'sort' . a:bang . ' '
                if len(a:args) <= 0 || a:args[0] != '/'
                    let cmd .= a:args
                else
                    let match = matchstrpos(a:args, '\%(/\)\@<=.*\%(/\)\@=')
                    if match[1] >= 0
                        let cmd .= '/' . E2v(match[0]) . '/ ' . strpart(a:args, match[2] + 1)
                    else
                        let cmd .= '/' . E2v(strpart(a:args, 1)) . '/'
                    endif
                endif

                execute cmd
            endfunction
            command! -nargs=* -range=% -bang Sort :call ZF_Plugin_eregex_sort('<bang>', <line1>, <line2>, <q-args>)
            augroup ZF_Plugin_eregex_augroup
                autocmd!
                autocmd User ZFVimrcPost
                            \ nnoremap / /\v|
                            \ nnoremap ? :M/|
                            \ nnoremap <leader>vr :.,$S//gec<left><left><left><left>|
                            \ xnoremap <leader>vr "ty:.,$S/<c-r>t//gec<left><left><left><left>|
                            \ nnoremap <leader>zr :.,$S//gec<left><left><left><left>\<<c-r><c-w>\>/|
                            \ xnoremap <leader>zr "ty:.,$S/\<<c-r>t\>//gec<left><left><left><left>|
                            \ nnoremap <leader>v/ :%S///gn<left><left><left><left>
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_fontsize')
            let g:ZF_Plugin_fontsize=1
        endif
        if g:ZF_Plugin_fontsize==1
            Plug 'drmikehenry/vim-fontsize'
            nmap + <plug>FontsizeInc
            nmap - <plug>FontsizeDec
            nmap -= <plug>FontsizeDefault
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_incsearch')
            let g:ZF_Plugin_incsearch=1
        endif
        if g:ZF_Plugin_incsearch==1
            Plug 'haya14busa/incsearch.vim'
            Plug 'haya14busa/incsearch-fuzzy.vim'
            function! ZF_Plugin_incsearch_fixPattern(pattern)
                let pattern = a:pattern
                let chars = map(split(pattern, '\zs'), "escape(v:val, '\\')")
                let nonword = strlen(matchstr(pattern, '[^0-9a-zA-Z_]')) > 0
                let p = '\V\<\=' .
                            \   join(map(chars[0:-2], "
                            \       printf('%s%s', v:val, nonword ? '\\.\\{-}' : '\\[0-9a-zA-Z_]\\{-}')
                            \   "), '') . chars[-1]
                return p
            endfunction
            function! ZF_Plugin_incsearch_setting()
                if !exists('g:loaded_incsearch_fuzzy')
                    return
                endif

                map <silent><expr> / incsearch#go({'converters' : [function('ZF_Plugin_incsearch_fixPattern')]})
                if has('clipboard')
                    cnoremap <s-insert> <c-r>*
                else
                    cnoremap <s-insert> <c-r>"
                endif
            endfunction
            augroup ZF_Plugin_incsearch_augroup
                autocmd!
                autocmd User ZFVimrcPost call ZF_Plugin_incsearch_setting()
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_LeaderF')
            let g:ZF_Plugin_LeaderF=1
        endif
        if g:ZF_Plugin_LeaderF==1
            if v:version < 704 || (v:version == 704 && has("patch330") == 0)
                let g:ZF_Plugin_LeaderF=0
            elseif has('python')
                if pyeval("sys.version_info < (2, 7)")
                    let g:ZF_Plugin_LeaderF=0
                endif
            elseif has('python3')
                if py3eval("sys.version_info < (3, 1)")
                    let g:ZF_Plugin_LeaderF=0
                endif
            else
                let g:ZF_Plugin_LeaderF=0
            endif
        endif
        if g:ZF_Plugin_LeaderF==1
            Plug 'Yggdroot/LeaderF'
            let g:Lf_ShortcutF = '<c-o>'
            let g:Lf_CursorBlink = 0
            let g:Lf_CacheDiretory = $HOME.'/.vim_cache/leaderf'
            function! ZF_Plugin_LeaderF_updateIgnore()
                let file = []
                let file += g:zf_exclude_common
                let file += g:zf_exclude_media
                let dir = []
                let dir += ZF_ExcludeExpandDir(g:zf_exclude_common_dir)
                let g:Lf_WildIgnore = {'file' : file, 'dir' : dir}
            endfunction
            call ZF_Plugin_LeaderF_updateIgnore()
            augroup ZF_Plugin_LeaderF_augroup
                autocmd!
                autocmd User ZFExcludeChanged call ZF_Plugin_LeaderF_updateIgnore()
            augroup END
            let g:Lf_MruMaxFiles = 0
            let g:Lf_StlSeparator = {'left' : '', 'right' : ''}
            let g:Lf_UseVersionControlTool = 0
            let g:Lf_CommandMap = {
                        \     '<c-c>' : ['<c-o>','<esc>'],
                        \     '<c-v>' : ['<c-g>'],
                        \     '<c-s>' : ['<c-a>'],
                        \     '<left>' : ['<c-h>'],
                        \     '<right>' : ['<c-l>'],
                        \ }
            nnoremap <silent> <leader>vo :LeaderfFile<cr>
            nnoremap <silent> <leader>zo :LeaderfFile<cr><f5>
        endif
        if !exists('g:ZF_Plugin_ctrlp')
            let g:ZF_Plugin_ctrlp=1
        endif
        if g:ZF_Plugin_LeaderF==1
            let g:ZF_Plugin_ctrlp=0
        endif
        if g:ZF_Plugin_ctrlp==1
            Plug 'ctrlpvim/ctrlp.vim'
            let g:ctrlp_by_filename = 1
            let g:ctrlp_regexp = 1
            let g:ctrlp_working_path_mode = ''
            let g:ctrlp_root_markers = []
            let g:ctrlp_use_caching = 1
            let g:ctrlp_clear_cache_on_exit = 0
            let g:ctrlp_cache_dir = $HOME.'/.vim_cache/ctrlp'
            let g:ctrlp_show_hidden = 1
            let g:ctrlp_prompt_mappings = {
                        \ 'MarkToOpen()':['<c-a>'],
                        \ 'PrtInsert("c")':['<MiddleMouse>','<insert>','<c-g>'],
                        \ 'OpenMulti()':['<c-y>'],
                        \ 'PrtExit()':['<esc>','<c-c>','<c-o>'],
                        \ }
            let g:ctrlp_abbrev = {
                        \ 'gmode': 'i',
                        \ 'abbrevs': []
                        \ }
            function! ZF_Plugin_ctrlp_keymap(c, n)
                for i in range(a:n)
                    let k = nr2char(char2nr(a:c) + i)
                    let g:ctrlp_abbrev['abbrevs'] += [{'pattern': k, 'expanded': k . '.*'}]
                endfor
            endfunction
            call ZF_Plugin_ctrlp_keymap('0', 10)
            call ZF_Plugin_ctrlp_keymap('a', 26)
            call ZF_Plugin_ctrlp_keymap('A', 26)
            call ZF_Plugin_ctrlp_keymap('-', 1)
            call ZF_Plugin_ctrlp_keymap('_', 1)
            let g:ctrlp_map = '<c-o>'
            nnoremap <silent> <leader>vo :CtrlP<cr>
            nnoremap <silent> <leader>zo :CtrlPClearAllCaches<cr>:CtrlP<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_linediff')
            let g:ZF_Plugin_linediff=1
        endif
        if g:ZF_Plugin_linediff==1
            Plug 'AndrewRadev/linediff.vim'
            let g:linediff_first_buffer_command='new'
            let g:linediff_second_buffer_command='vertical new'

            function! ZF_Plugin_linediff_Diff(line1, line2)
                let splitright_old=&splitright
                set splitright
                call linediff#Linediff(a:line1, a:line2, {})
                let &splitright=splitright_old
                if &diff == 1
                    execute "normal! \<c-w>l"
                endif
            endfunction
            command! -range LinediffBeginWrap call ZF_Plugin_linediff_Diff(<line1>, <line2>)
            xnoremap ZD :LinediffBeginWrap<cr>

            function! ZF_Plugin_linediff_DiffExit()
                while 1
                    if &diff != 1
                        break
                    endif

                    execute "normal! \<c-w>h"
                    let modified=&modified
                    execute "normal! \<c-w>l"
                    let modified=(modified||&modified)
                    if modified != 1
                        break
                    endif

                    echo 'diff updated, save?'
                    echo '  (y)es'
                    echo '  (n)o'
                    echo 'choose: '
                    let cmd=getchar()
                    if cmd != char2nr('y')
                        break
                    endif

                    execute "normal! \<c-w>h"
                    update
                    execute "normal! \<c-w>l"
                    update
                    bd
                    redraw!
                    echo 'diff updated'
                    return
                endwhile

                execute 'LinediffReset!'
                redraw!
                echo 'diff canceled'
            endfunction
            nnoremap ZD :call ZF_Plugin_linediff_DiffExit()<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_matchit')
            let g:ZF_Plugin_matchit=1
        endif
        if g:ZF_Plugin_matchit==1
            Plug 'vim-scripts/matchit.zip'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_nerdtree')
            let g:ZF_Plugin_nerdtree=1
        endif
        if g:ZF_Plugin_nerdtree==1
            Plug 'scrooloose/nerdtree'
            let NERDTreeSortHiddenFirst=1
            let NERDTreeQuitOnOpen=1
            let NERDTreeShowHidden=1
            let NERDTreeShowLineNumbers=1
            let NERDTreeWinSize=50
            let NERDTreeMinimalUI=1
            let NERDTreeDirArrows=0
            let NERDTreeAutoDeleteBuffer=1
            let NERDTreeHijackNetrw=1
            let NERDTreeBookmarksFile=$HOME.'/.vim_cache/.NERDTreeBookmarks'
            let g:NERDTreeDirArrowExpandable='+'
            let g:NERDTreeDirArrowCollapsible='~'
            let g:NERDTreeRemoveDirCmd='rm -rf '
            let g:NERDTreeCopyDirCmd='cp -rf '
            let g:NERDTreeCopyFileCmd='cp -rf '
            nnoremap <silent> <leader>ve :NERDTreeToggle<cr>
            nnoremap <silent> <leader>ze :NERDTreeFind<cr>
            augroup ZF_Plugin_nerdtree_augroup
                autocmd!
                autocmd FileType nerdtree
                            \ setlocal tabstop=2|
                            \ nmap <buffer> <leader>ze :NERDTreeToggle<cr>:NERDTreeFind<cr>|
                            \ nmap <buffer> cd <leader>NT?cd<leader>NT?CD:pwd<cr>|
                            \ nmap <buffer> X gg<leader>NT?X|
                            \ nmap <buffer> u <leader>NT?u:let _l=line('.')<cr>gg<leader>NT?cd<leader>NT?CD:<c-r>=_l<cr><cr>:pwd<cr>
            augroup END
            let g:NERDTreeMapActivateNode='o'
            let g:NERDTreeMapChangeRoot='<leader>NT?CD'
            let g:NERDTreeMapChdir='<leader>NT?cd'
            let g:NERDTreeMapCloseChildren='<leader>NT?X'
            let g:NERDTreeMapCloseDir='x'
            let g:NERDTreeMapDeleteBookmark=''
            let g:NERDTreeMapMenu='m'
            let g:NERDTreeMapHelp='?'
            let g:NERDTreeMapJumpFirstChild='zh'
            let g:NERDTreeMapJumpLastChild='zl'
            let g:NERDTreeMapJumpNextSibling='zj'
            let g:NERDTreeMapJumpParent='zu'
            let g:NERDTreeMapJumpPrevSibling='zk'
            let g:NERDTreeMapJumpRoot=''
            let g:NERDTreeMapOpenExpl=''
            let g:NERDTreeMapOpenInTab=''
            let g:NERDTreeMapOpenInTabSilent=''
            let g:NERDTreeMapOpenRecursively='O'
            let g:NERDTreeMapOpenSplit=''
            let g:NERDTreeMapOpenVSplit=''
            let g:NERDTreeMapPreview=''
            let g:NERDTreeMapPreviewSplit=''
            let g:NERDTreeMapPreviewVSplit=''
            let g:NERDTreeMapQuit='q'
            let g:NERDTreeMapRefresh='R'
            let g:NERDTreeMapRefreshRoot='r'
            let g:NERDTreeMapToggleBookmarks=''
            let g:NERDTreeMapToggleFiles=''
            let g:NERDTreeMapToggleFilters=''
            let g:NERDTreeMapToggleHidden='ch'
            let g:NERDTreeMapToggleZoom=''
            let g:NERDTreeMapUpdir='<leader>NT?u'
            let g:NERDTreeMapUpdirKeepOpen=''
            let g:NERDTreeMapCWD='CD'

            Plug 'jistr/vim-nerdtree-tabs'
            let g:nerdtree_tabs_startup_cd=0
            let g:nerdtree_tabs_open_on_gui_startup=0
            let g:nerdtree_tabs_open_on_console_startup=0
            let g:nerdtree_tabs_no_startup_for_diff=1

            Plug 'ZSaberLv0/nerdtree_menu_util'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ShowTrailingWhitespace')
            let g:ZF_Plugin_ShowTrailingWhitespace=1
        endif
        if g:ZF_Plugin_ShowTrailingWhitespace==1
            Plug 'vim-scripts/ShowTrailingWhitespace'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_signature')
            let g:ZF_Plugin_signature=1
        endif
        if g:ZF_Plugin_signature==1
            Plug 'kshenoy/vim-signature'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_supertab')
            let g:ZF_Plugin_supertab=1
        endif
        if g:ZF_Plugin_supertab==1
            Plug 'ervandew/supertab'
            let g:SuperTabDefaultCompletionType='context'
            let g:SuperTabContextDefaultCompletionType='<c-p>'
            let g:SuperTabCompletionContexts=['s:ContextText', 's:ContextDiscover']
            let g:SuperTabContextTextOmniPrecedence=['&omnifunc', '&completefunc']
            let g:SuperTabContextDiscoverDiscovery=['&completefunc:<c-x><c-u>', '&omnifunc:<c-x><c-o>']
            let g:SuperTabLongestEnhanced=1
            let g:SuperTabLongestHighlight=1
            augroup ZF_Plugin_supertab_augroup
                autocmd!
                autocmd FileType,VimEnter *
                            \ if &omnifunc!='' && exists('*SuperTabChain') && exists('*SuperTabSetDefaultCompletionType')|
                            \     call SuperTabChain(&omnifunc, '<c-p>')|
                            \     call SuperTabSetDefaultCompletionType('<c-x><c-u>')|
                            \ endif
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_surround')
            let g:ZF_Plugin_surround=1
        endif
        if g:ZF_Plugin_surround==1
            Plug 'tpope/vim-surround'
            let g:surround_no_mappings=1
            let g:surround_no_insert_mappings=1
            nmap rd <plug>Dsurround
            nmap RD <plug>Dsurround
            nmap rc <plug>Csurround
            nmap RC <plug>CSurround
            xmap r <plug>VSurround
            xmap R <plug>VgSurround
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_tagbar')
            let g:ZF_Plugin_tagbar=1
        endif
        if g:ZF_Plugin_tagbar==1
            Plug 'majutsushi/tagbar'
            let g:tagbar_width=80
            let g:tagbar_autoclose=1
            let g:tagbar_autofocus=1
            let g:tagbar_sort=0
            let g:tagbar_compact=1
            let g:tagbar_show_linenumbers=1
            let g:tagbar_show_visibility=0
            let g:tagbar_autoshowtag=1
            let g:tagbar_map_togglefold='o'
            let g:tagbar_map_openallfolds='O'
            let g:tagbar_map_closefold='x'
            let g:tagbar_map_closeallfolds='X'
            let g:tagbar_map_togglesort=''
            let g:tagbar_map_toggleautoclose=''
            let g:tagbar_map_zoomwin=''

            nnoremap <silent> <leader>vt :TagbarToggle<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_VimIM')
            let g:ZF_Plugin_VimIM=1
        endif
        if g:ZF_Plugin_VimIM==1
            " Plug 'vim-scripts/VimIM'
            Plug 'ZSaberLv0/VimIM'
            let g:Vimim_map='no-gi'
            let g:Vimim_punctuation=0
            let g:Vimim_toggle='pinyin,baidu'
            augroup ZF_Plugin_VimIM_augroup
                autocmd!
                autocmd User ZFVimrcPost
                            \ nnoremap <silent> ;; i<C-R>=g:Vimim_chinese()<CR><Esc>l|
                            \ inoremap <silent> ;; <C-R>=g:Vimim_chinese()<CR>|
                            \ nnoremap <silent> ;: i<C-R>=g:Vimim_onekey()<CR><Esc>l|
                            \ inoremap <silent> ;: <C-R>=g:Vimim_onekey()<CR>
            augroup END

            Plug 'ZSaberLv0/VimIM_db'
            Plug 'ZSaberLv0/VimIMSync'
            let g:VimIMSync_repo_head='https://'
            let g:VimIMSync_repo_tail='github.com/ZSaberLv0/VimIM_db'
            let g:VimIMSync_user='ZSaberLv0'
            let g:VimIMSync_file='plugin/vimim.baidu.txt'

            function! ZF_Plugin_VimIMSync_add()
                normal! `>
            endfunction
            nnoremap ;, :IMAdd<space>
            xnoremap ;, "ty:let g:VimIMSync_actionFinishCallback='ZF_Plugin_VimIMSync_add'<cr>:IMAdd <c-r>t<space>

            function! ZF_Plugin_VimIMSync_remove()
                normal! gv"_d
            endfunction
            nnoremap ;. :IMRemove<space>
            xnoremap ;. "ty:let g:VimIMSync_actionFinishCallback='ZF_Plugin_VimIMSync_remove'<cr>:IMRemove <c-r>t<cr>

            function! ZF_Plugin_VimIM_viewDB()
                execute 'edit ' . globpath(&rtp, g:VimIMSync_file)
            endfunction
            command! -nargs=0 IMView :call ZF_Plugin_VimIM_viewDB()
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_wildfire')
            let g:ZF_Plugin_wildfire=1
        endif
        if g:ZF_Plugin_wildfire==1
            Plug 'gcmt/wildfire.vim'
            let g:wildfire_objects=[]
            let g:wildfire_objects+=["i'", 'i"', 'i`', 'i)', 'i]', 'i}', 'i>', 'it']
            let g:wildfire_objects+=["a'", 'a"', 'a`', 'a)', 'a]', 'a}', 'a>', 'at']
            " we want no map in select mode
            let g:wildfire_fuel_map='<leader>v?wildfire?t'
            let g:wildfire_water_map='<leader>v?wildfire?T'
            nmap t <Plug>(wildfire-fuel)
            xmap t <Plug>(wildfire-fuel)
            xmap T <Plug>(wildfire-water)
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_youdao_translater')
            let g:ZF_Plugin_youdao_translater=1
        endif
        if (!has('python') && !has('python3'))
            let g:ZF_Plugin_youdao_translater=0
        endif
        if g:ZF_Plugin_youdao_translater==1
            Plug 'ianva/vim-youdao-translater'
            xnoremap <leader>vy <esc>:Ydv<cr>
            nnoremap <leader>vy :Yde<cr><c-r><c-w>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimCmdMenu')
            let g:ZF_Plugin_ZFVimCmdMenu=1
        endif
        if g:ZF_Plugin_ZFVimCmdMenu==1
            Plug 'ZSaberLv0/ZFVimCmdMenu'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimEscape')
            let g:ZF_Plugin_ZFVimEscape=1
        endif
        if g:ZF_Plugin_ZFVimEscape==1
            Plug 'ZSaberLv0/ZFVimEscape'
            xnoremap <leader>ce <esc>:call ZF_VimEscape('v')<cr>
            nnoremap <leader>ce :call ZF_VimEscape()<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimFoldBlock')
            let g:ZF_Plugin_ZFVimFoldBlock=1
        endif
        if g:ZF_Plugin_ZFVimFoldBlock==1
            Plug 'ZSaberLv0/ZFVimFoldBlock'
            nnoremap ZB q::call ZF_FoldBlockTemplate()<cr>
            nnoremap ZF :ZFFoldBlock //<left>
            function! ZF_Plugin_ZFVimFoldBlock_comment()
                let expr='\(^\s*\/\/\)'
                if &filetype=='vim'
                    let expr.='\|\(^\s*"\)'
                endif
                if &filetype=='c' || &filetype=='cpp'
                    let expr.='\|\(^\s*\(\(\/\*\)\|\(\*\)\)\)'
                endif
                if &filetype=='make'
                    let expr.='\|\(^\s*#\)'
                endif
                let disableE2vSaved = g:ZFVimFoldBlock_disableE2v
                let g:ZFVimFoldBlock_disableE2v = 1
                call ZF_FoldBlock('/' . expr . '//')
                let g:ZFVimFoldBlock_disableE2v = disableE2vSaved
                echo 'comments folded'
            endfunction
            nnoremap ZC :call ZF_Plugin_ZFVimFoldBlock_comment()<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimFormater')
            let g:ZF_Plugin_ZFVimFormater=1
        endif
        if g:ZF_Plugin_ZFVimFormater==1
            Plug 'ZSaberLv0/ZFVimFormater'
            Plug 'elzr/vim-json'
            Plug 'Chiel92/vim-autoformat'
            Plug 'rhysd/vim-clang-format'
            let g:vim_json_syntax_conceal=0
            nnoremap <leader>cf :call ZF_Formater()<cr>
            " recommended format tools (require python pip)
            "   apt-get install astyle tidy
            "   pip install -U pip
            "   pip install jsbeautifier yapf
            "
            " note, for Windows python users, you may want to:
            " -  rename `~/Python/Scripts/js-beautify` to `~/Python/Scripts/js-beautify.py`
            " -  add `.py` to `PATHEXT`
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimIndentMove')
            let g:ZF_Plugin_ZFVimIndentMove=1
        endif
        if g:ZF_Plugin_ZFVimIndentMove==1
            Plug 'ZSaberLv0/ZFVimIndentMove'
            nnoremap E <nop>
            nnoremap EE ``
            nnoremap EH :call ZF_IndentMoveParent('n')<cr>
            xnoremap EH :<c-u>call ZF_IndentMoveParent('v')<cr>
            nnoremap EL :call ZF_IndentMoveParentEnd('n')<cr>
            xnoremap EL :<c-u>call ZF_IndentMoveParentEnd('v')<cr>
            nnoremap EK :call ZF_IndentMovePrev('n')<cr>
            xnoremap EK :<c-u>call ZF_IndentMovePrev('v')<cr>
            nnoremap EJ :call ZF_IndentMoveNext('n')<cr>
            xnoremap EJ :<c-u>call ZF_IndentMoveNext('v')<cr>
            nnoremap EI :call ZF_IndentMoveChild('n')<cr>
            xnoremap EI :<c-u>call ZF_IndentMoveChild('v')<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimTxtHighlight')
            let g:ZF_Plugin_ZFVimTxtHighlight=1
        endif
        if g:ZF_Plugin_ZFVimTxtHighlight==1
            Plug 'ZSaberLv0/ZFVimTxtHighlight'
            nnoremap <leader>cth :call ZF_VimTxtHighlightToggle()<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimrcUtil')
            let g:ZF_Plugin_ZFVimrcUtil=1
        endif
        if g:ZF_Plugin_ZFVimrcUtil==1
            Plug 'ZSaberLv0/ZFVimrcUtil'
            nnoremap <leader>vimrc :call ZF_VimrcEdit()<cr>
            nnoremap <leader>vimrt :call ZF_VimrcEditOrg()<cr>
            nnoremap <leader>vimclean :call ZF_VimClean()<cr>
            nnoremap <leader>vimrd :call ZF_VimrcDiff()<cr>
            nnoremap <leader>vimru :call ZF_VimrcUpdate()<cr>
            nnoremap <leader>vimrp :call ZF_VimrcPush()<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimTagSetting')
            let g:ZF_Plugin_ZFVimTagSetting=1
        endif
        if g:ZF_Plugin_ZFVimTagSetting==1
            Plug 'ZSaberLv0/ZFVimTagSetting'
            nnoremap <leader>ctagl :call ZF_TagsFileLocal()<cr>
            nnoremap <leader>ctagg :call ZF_TagsFileGlobal()<cr>
            nnoremap <leader>ctaga :call ZF_TagsFileGlobalAdd()<cr>
            nnoremap <leader>ctagr :call ZF_TagsFileRemove()<cr>
            nnoremap <leader>ctagv :execute ':edit ' . ZF_TagsFileGlobalPath()<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimUtil')
            let g:ZF_Plugin_ZFVimUtil=1
        endif
        if g:ZF_Plugin_ZFVimUtil==1
            Plug 'ZSaberLv0/ZFVimUtil'
            nnoremap <leader>vs :ZFExecShell<space>
            nnoremap <leader>vc :ZFExecCmd<space>
            nnoremap <leader>calc :ZFCalc<space>
            nnoremap <leader>vdf :ZFDiffFile<space>
            nnoremap <leader>vdb :ZFDiffBuffer<space>
            nnoremap <leader>vde :ZFDiffExit<cr>
            nnoremap <leader>vvo :ZFOpenAllFileInClipboard<cr>
            nnoremap <leader>vvs :ZFRunShellScriptInClipboard<cr>
            nnoremap <leader>vvc :ZFRunVimCommandInClipboard<cr>
            nnoremap <leader>vn :ZFNumberConvert<cr>
            nnoremap ZB q::call ZF_FoldBlockTemplate()<cr>
            nnoremap Z) :call ZF_FoldBrace(')')<cr>
            nnoremap Z] :call ZF_FoldBrace(']')<cr>
            nnoremap Z} :call ZF_FoldBrace('}')<cr>
            nnoremap Z> :call ZF_FoldBrace('>')<cr>
            nnoremap <leader>cc :call ZF_Convert()<cr>
            nnoremap <leader>cm :call ZF_Toggle()<cr>
        endif
    endif " common plugins for happy text editing

    " ==================================================
    if 1 " additional plugins for language spec
        " ==================================================
        if !exists('g:ZF_Plugin_a')
            let g:ZF_Plugin_a=1
        endif
        if g:ZF_Plugin_a==1
            Plug 'taxilian/a.vim'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_caw')
            let g:ZF_Plugin_caw=1
        endif
        if g:ZF_Plugin_caw==1
            Plug 'tyru/caw.vim'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_DoxygenToolkit')
            let g:ZF_Plugin_DoxygenToolkit=1
        endif
        if g:ZF_Plugin_DoxygenToolkit==1
            Plug 'vim-scripts/DoxygenToolkit.vim'
            let g:load_doxygen_syntax=1
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_syntastic')
            let g:ZF_Plugin_syntastic=1
        endif
        if g:ZF_Plugin_syntastic==1
            Plug 'vim-syntastic/syntastic'
            if exists('*SyntasticStatuslineFlag')
                set statusline-=%#warningmsg#
                set statusline+=%#warningmsg#
                set statusline-=%{SyntasticStatuslineFlag()}
                set statusline+=%{SyntasticStatuslineFlag()}
                set statusline-=%*
                set statusline+=%*
            endif
            let g:syntastic_always_populate_loc_list = 1
            let g:syntastic_auto_loc_list = 0
            let g:syntastic_check_on_open = 1
            let g:syntastic_check_on_wq = 0
            let g:syntastic_mode_map = {'mode' : 'passive'}
            if g:zf_windows==1
                " this would hang if SHELL is cmd.exe
                let g:syntastic_sh_checkers = []
            endif
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_polyglot')
            let g:ZF_Plugin_polyglot=1
        endif
        if g:ZF_Plugin_polyglot==1
            Plug 'sheerun/vim-polyglot'
            let g:polyglot_disabled = ['markdown']
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_YouCompleteMe')
            let g:ZF_Plugin_YouCompleteMe=0
        endif
        if g:zf_windows==1 || v:version < 800 || (!has('python') && !has('python3'))
            let g:ZF_Plugin_YouCompleteMe=0
        endif
        if g:ZF_Plugin_YouCompleteMe==1
            Plug 'Valloric/YouCompleteMe', {'do' : './install.py --clang-completer'}
            let g:ycm_confirm_extra_conf=0
            let g:ycm_key_invoke_completion = '<c-x><c-u>'
            let g:ycm_key_list_select_completion = ['<Down>']
            let g:ycm_key_list_previous_completion = ['<Up>']
            let g:ycm_semantic_triggers = {
                        \     'c,cpp,objcpp' : 're![a-zA-Z_]',
                        \ }
            augroup ZF_Plugin_YouCompleteMe_augroup
                autocmd!
                autocmd User ZFVimrcPost
                            \ nnoremap zj :YcmCompleter GoTo<cr>|
                            \ nnoremap zk <c-o>
            augroup END

            Plug 'ZSaberLv0/ycm_conf_default'
            let g:ycm_global_ycm_extra_conf = $HOME . '/.vim/bundle/ycm_conf_default/ycm_extra_conf.py'

            Plug 'tenfyzhong/CompleteParameter.vim'
            function! ZF_Plugin_CompleteParameter_tab(forward)
                if pumvisible()
                    return a:forward ? "\<c-n>" : "\<c-p>"
                endif
                if cmp#jumpable(a:forward)
                    if a:forward
                        return "\<Plug>(complete_parameter#goto_next_parameter)"
                    else
                        return "\<Plug>(complete_parameter#goto_previous_parameter)"
                    endif
                endif
                if a:forward
                    let line = getline('.')
                    let col = col('.')
                    if col <= 1 || len(line) < col - 2 || line[col - 2] == ' ' || line[col - 2] == "\<tab>"
                        return "\<tab>"
                    endif
                    return "\<c-x>\<c-u>"
                endif
                return ''
            endfunction
            function! ZF_Plugin_CompleteParameter_setting()
                inoremap <silent><expr> <cr> pumvisible() ? "\<c-y>" . complete_parameter#pre_complete('') : "\<c-g>u\<cr>"|
                map <tab> <Plug>(complete_parameter#goto_next_parameter)
                map <s-tab> <Plug>(complete_parameter#goto_previous_parameter)
                imap <silent><expr> <tab> '' . ZF_Plugin_CompleteParameter_tab(1)
                imap <silent><expr> <s-tab> '' . ZF_Plugin_CompleteParameter_tab(0)
            endfunction
            augroup ZF_Plugin_CompleteParameter_augroup
                autocmd!
                autocmd User ZFVimrcPost call ZF_Plugin_CompleteParameter_setting()
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_clang_complete')
            let g:ZF_Plugin_clang_complete=1
        endif
        if g:ZF_Plugin_YouCompleteMe==1 || !has('python')
            let g:ZF_Plugin_clang_complete=0
        endif
        if g:ZF_Plugin_clang_complete==1
            Plug 'Rip-Rip/clang_complete'
            let g:clang_auto_select=1
            let g:clang_complete_auto=0
            let g:clang_snippets=1
            let g:clang_close_preview=1
            let g:clang_sort_algo='alpha'
            let g:clang_jumpto_declaration_key='zj'
            let g:clang_jumpto_back_key='zk'
            " let g:clang_user_options+='-I'
            let g:clang_complete_macros=1
            let g:clang_complete_patterns=1
            let g:clang_make_default_keymappings=1
            let g:clang_use_library=1
            if !exists('g:clang_library_path') || g:clang_library_path == ''
                if g:zf_windows==1
                    if filereadable('C:\Program Files\LLVM\bin\libclang.dll')
                        let g:clang_library_path=expand('C:\Program Files\LLVM\bin')
                    elseif filereadable('C:\Program Files (x86)\LLVM\bin\libclang.dll')
                        let g:clang_library_path=expand('C:\Program Files (x86)\LLVM\bin')
                    elseif filereadable($VIMRUNTIME . 'libclang.dll')
                        let g:clang_library_path=$VIMRUNTIME
                    elseif filereadable($HOME . '/clang/bin/libclang.dll')
                        let g:clang_library_path=expand($HOME . '/clang/bin')
                    else
                        let g:clang_library_path=expand('C:\Program Files\LLVM\bin')
                    endif
                elseif g:zf_mac==1 && filereadable('/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib')
                    let g:clang_library_path='/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'
                elseif filereadable('/usr/lib/libclang.a')
                            \ || filereadable('/usr/lib/libclang.so')
                            \ || filereadable('/usr/lib/libclang.dll')
                            \ || filereadable('/usr/lib/libclang.dll.a')
                            \ || filereadable('/usr/lib/libclang.dll.so')
                            \ || filereadable('/usr/lib/libclang.dylib')
                    let g:clang_library_path='/usr/lib'
                else
                    let g:clang_library_path='/usr/local/lib'
                endif
            endif
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_markdown')
            let g:ZF_Plugin_markdown=1
        endif
        if g:ZF_Plugin_markdown==1
            let g:ZF_Plugin_markdown_ftList = []
            function! ZF_Plugin_vim_markdown_init(v)
                let searchSaved = @/
                let cursorSaved = getcurpos()
                let ftList = deepcopy(g:ZF_Plugin_markdown_ftList)
                let tmpList = []
                silent! g/^[ \t]*```[ \t]*[a-z0-9_]\+[ \t]*$/execute 'call add(tmpList, getline("."))'
                for item in tmpList
                    let t = substitute(item, '^[ \t]*```[ \t]*\([a-z0-9_]\+\)[ \t]*$', '\1', 'g')
                    if !empty(t)
                        call add(ftList, t)
                    endif
                endfor
                let @/ = searchSaved
                call setpos('.', cursorSaved)
                call uniq(sort(ftList))
                let i = 0
                while i < len(ftList)
                    if empty(globpath(&rtp, 'syntax/' . ftList[i] . '.vim'))
                        call remove(ftList, i)
                    else
                        let i += 1
                    endif
                endwhile
                let g:ZF_Plugin_markdown_ftList = ftList
                execute 'let ' . a:v . ' = ftList'
            endfunction
            if 1
                Plug 'rhysd/vim-gfm-syntax'
                let ZF_Plugin_vim_markdown_cfg = 'g:markdown_fenced_languages'
            else
                Plug 'plasticboy/vim-markdown'
                let ZF_Plugin_vim_markdown_cfg = 'g:vim_markdown_fenced_languages'
            endif
            augroup ZF_Plugin_vim_markdown_augroup
                autocmd!
                autocmd FileType markdown call ZF_Plugin_vim_markdown_init(ZF_Plugin_vim_markdown_cfg)
                autocmd BufWritePost *
                            \ if &filetype == 'markdown'|
                            \     call ZF_Plugin_vim_markdown_init(ZF_Plugin_vim_markdown_cfg)|
                            \     set syntax=|
                            \     set syntax=markdown|
                            \ endif
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_markdown_preview')
            let g:ZF_Plugin_markdown_preview=1
        endif
        if g:ZF_Plugin_markdown_preview==1
            Plug 'iamcco/markdown-preview.vim'
            let g:mkdp_auto_start=0
            let g:mkdp_auto_open=0
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_markdown_toc')
            let g:ZF_Plugin_markdown_toc=1
        endif
        if g:ZF_Plugin_markdown_toc==1
            Plug 'mzlogin/vim-markdown-toc'
            command! -nargs=0 TOCAdd :GenTocGFM
            command! -nargs=0 TOCRemove :RemoveToc
            command! -nargs=0 TOCUpdate :UpdateToc
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_ZFVimMarkdownToc')
            let g:ZF_Plugin_ZFVimMarkdownToc=1
        endif
        if g:ZF_Plugin_ZFVimMarkdownToc==1
            Plug 'ZSaberLv0/ZFVimMarkdownToc'
            augroup ZF_Plugin_ZFVimMarkdownToc_augroup
                autocmd!
                autocmd FileType markdown
                            \ nnoremap <buffer> [[ :call ZF_MarkdownTitlePrev('n')<cr>|
                            \ xnoremap <buffer> [[ :call ZF_MarkdownTitlePrev('v')<cr>|
                            \ nnoremap <buffer> ]] :call ZF_MarkdownTitleNext('n')<cr>|
                            \ xnoremap <buffer> ]] :call ZF_MarkdownTitleNext('v')<cr>|
                            \ nnoremap <buffer> <leader>vt :call ZF_MarkdownToc()<cr>
            augroup END
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_fenced_code_blocks')
            let g:ZF_Plugin_fenced_code_blocks=1
        endif
        if g:ZF_Plugin_fenced_code_blocks==1
            Plug 'amiorin/vim-fenced-code-blocks'
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_php_namespace')
            let g:ZF_Plugin_php_namespace=1
        endif
        if g:ZF_Plugin_php_namespace==1
            Plug 'arnaud-lb/vim-php-namespace'
            let g:php_namespace_sort_after_insert = 1
            nnoremap <leader>cphpu :call PhpInsertUse()<cr>
            nnoremap <leader>cphpe :call PhpExpandClass()<cr>
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_PIV')
            let g:ZF_Plugin_PIV=1
        endif
        if g:ZF_Plugin_PIV==1
            Plug 'spf13/PIV'
            let g:PIVCreateDefaultMappings=0
            let g:DisableAutoPHPFolding=1
        endif
        " ==================================================
        if !exists('g:ZF_Plugin_xmledit')
            let g:ZF_Plugin_xmledit=1
        endif
        if g:ZF_Plugin_xmledit==1
            Plug 'sukima/xmledit'
        endif
    endif " additional plugins for language spec


    " ==================================================
    call plug#end()
endif " if g:zf_no_plugin!=1


" ==================================================
if 1 " themes
    " themes should be set before other vim settings
    if g:zf_colorscheme_256 && !empty(globpath(&rtp, 'colors/' . g:zf_color_name_256 . '.vim'))
        execute 'colorscheme ' . g:zf_color_name_256
        execute 'set background=' . g:zf_color_bg_256
    elseif !empty(globpath(&rtp, 'colors/' . g:zf_color_name_default . '.vim'))
        execute 'colorscheme ' . g:zf_color_name_default
        execute 'set background=' . g:zf_color_bg_default
    else
        colorscheme murphy
        set background=dark
    endif
endif " themes


" ==================================================
if 1 " custom key mapping
    " esc
    if g:zf_fakevim!=1
        inoremap <esc> <esc>l
    else
        iunmap <esc>
    endif
    inoremap jk <esc>l
    cnoremap jk <c-c>
    if g:zf_fakevim!=1
        nnoremap <space> <esc>
        xnoremap <space> <esc>
        onoremap <space> <esc>
    else
        noremap <space> <esc>
    endif
    " visual
    if g:zf_fakevim!=1
        nnoremap V <c-v>
        xnoremap V <c-v>
        nnoremap <c-v> V
        xnoremap <c-v> V
    else
        nnoremap V <c-v>
        vnoremap V <c-v>
        nnoremap <c-v> V
        vnoremap <c-v> V
    endif
    " special select mode mapping
    " some plugin use vmap, which would cause unexpected behavior under select mode
    if g:zf_fakevim!=1
        let s:_selectmode_keys='abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890~!@#$%^&*-_=+\\|;:,./?)]}>'
        for i in range(strlen(s:_selectmode_keys))
            silent! execute 'snoremap <silent> ' . s:_selectmode_keys[i] . ' <c-g>"_c' . s:_selectmode_keys[i]
        endfor
        silent! snoremap <silent> <space> <esc>
        silent! snoremap <silent> jk <esc>gv
        silent! snoremap <silent> <bs> <c-g>"_c
        silent! snoremap <silent> ( <c-g>"_c()<esc>i
        silent! snoremap <silent> [ <c-g>"_c[]<esc>i
        silent! snoremap <silent> { <c-g>"_c{}<esc>i
        silent! snoremap <silent> < <c-g>"_c<><esc>i
        silent! snoremap <silent> ' <c-g>"_c''<esc>i
        silent! snoremap <silent> " <c-g>"_c""<esc>i
        silent! snoremap <silent> ` <c-g>"_c``<esc>i
    endif
    " scrolling
    nnoremap <c-h> zh
    nnoremap <c-l> zl
    nnoremap <c-j> <c-e>
    nnoremap <c-k> <c-y>
    inoremap <c-h> <left>
    inoremap <c-l> <right>
    inoremap <c-j> <down>
    inoremap <c-k> <up>
    cnoremap <c-h> <left>
    cnoremap <c-l> <right>
    cnoremap <c-j> <down>
    cnoremap <c-k> <up>
    nnoremap H :bp<cr>
    nnoremap L :bn<cr>
    if g:zf_fakevim!=1
        nnoremap J <c-f>
        xnoremap J <c-f>
        nnoremap K <c-b>
        xnoremap K <c-b>
    else
        noremap J <c-f>
        noremap K <c-b>
    endif
    " move
    if g:zf_fakevim!=1
        nmap z, %
        xmap z, %
        omap z, %

        nnoremap , $
        xnoremap , $
        onoremap , $
        nnoremap g, g$
        xnoremap g, g$
        onoremap g, g$

        nnoremap j gj
        xnoremap j gj
        onoremap j gj
        nnoremap gj j
        xnoremap gj j
        onoremap gj j

        nnoremap k gk
        xnoremap k gk
        onoremap k gk
        nnoremap gk k
        xnoremap gk k
        onoremap gk k
    else
        map z, %
        noremap , $
        noremap j gj
        noremap k gk
        unmap g,
        unmap gj
        unmap gk
    endif
    " brace jump
    nnoremap zg <nop>

    nnoremap zg) va)<esc>h%
    nnoremap z) va)<esc>h
    xnoremap zg) <esc>`<mz`>va)<esc>h%m>`zm<:delmarks z<cr>gv
    xnoremap z) <esc>`<mz`>va)<esc>`zm<:delmarks z<cr>gvh

    nnoremap zg] va]<esc>h%
    nnoremap z] va]<esc>h
    xnoremap zg] <esc>`<mz`>va]<esc>h%m>`zm<:delmarks z<cr>gv
    xnoremap z] <esc>`<mz`>va]<esc>`zm<:delmarks z<cr>gvh

    nnoremap zg} va}<esc>h%
    nnoremap z} va}<esc>h
    xnoremap zg} <esc>`<mz`>va}<esc>h%m>`zm<:delmarks z<cr>gv
    xnoremap z} <esc>`<mz`>va}<esc>`zm<:delmarks z<cr>gvh

    nnoremap zg> va><esc>h%
    nnoremap z> va><esc>h
    xnoremap zg> <esc>`<mz`>va><esc>h%m>`zm<:delmarks z<cr>gv
    xnoremap z> <esc>`<mz`>va><esc>`zm<:delmarks z<cr>gvh

    nnoremap zg" vi"<esc>`<h
    nnoremap z" vi"<esc>
    xnoremap zg" <esc>`<mz`>vi"<esc>`<m>`zm<:delmarks z<cr>gv
    xnoremap z" <esc>`<mz`>vi"<esc>`zm<:delmarks z<cr>gv

    nnoremap zg' vi'<esc>`<h
    nnoremap z' vi'<esc>
    xnoremap zg' <esc>`<mz`>vi'<esc>`<m>`zm<:delmarks z<cr>gv
    xnoremap z' <esc>`<mz`>vi'<esc>`zm<:delmarks z<cr>gv

    nmap zg; zg}
    nmap z; z}
    xmap zg; zg}
    xmap z; z}
    " go to define
    nnoremap zj <c-]>
    nnoremap zk <c-t>
    nnoremap zh :tprevious<cr>
    nnoremap zl :tnext<cr>
    " redo
    nnoremap U <c-r>
    " modify/delete without change clipboard
    if g:zf_fakevim!=1
        nnoremap c "_c
        xnoremap c "_c
        nnoremap d "_d
        xnoremap d "_d
    else
        nunmap c
        xunmap c
        nunmap d
        xunmap d
    endif
    nnoremap <del> "_dl
    vnoremap <del> "_d
    inoremap <del> <right><bs>
    " always use system clipboard
    set clipboard+=unnamed
    if has('clipboard')
        nnoremap zp :let @"=@*<cr>:echo 'copied from system clipboard'<cr>
    else
        nnoremap zp <nop>
    endif
    nnoremap p gP
    xnoremap p "_dgP
    nnoremap P gp
    xnoremap P "_dgp
    function! ZF_Setting_VisualPaste()
        normal! gv
        if mode() != ""
            if has('clipboard')
                normal! "_d"*gP
            else
                normal! "_dgP
            endif
        endif
    endfunction
    nmap <c-g> p
    xnoremap <c-g> <esc>:call ZF_Setting_VisualPaste()<cr>
    if has('clipboard')
        inoremap <c-g> <c-r>*
        cnoremap <c-g> <c-r>*
        snoremap <c-g> <c-o>"_d"*gP
    else
        if g:zf_fakevim!=1
            inoremap <c-g> <c-r>"
            cnoremap <c-g> <c-r>"
            snoremap <c-g> <c-o>"_dgP
        else
            inoremap <c-g> <c-r>0
            cnoremap <c-g> <c-r>0
            snoremap <c-g> <c-o>0_dgP
        endif
    endif
    " window and buffer management
    nnoremap B :bufdo<space>
    nnoremap zs :w<cr>
    nnoremap ZS :wa<cr>
    nnoremap zx :w<cr>:bd<cr>
    nnoremap ZX :wa<cr>:bufdo bd<cr>
    nnoremap cx :bd!<cr>
    nnoremap CX :bufdo bd!<cr>
    nnoremap x :bd<cr>
    command! W w !sudo tee % > /dev/null

    nnoremap WH <c-w>h
    nnoremap WL <c-w>l
    nnoremap WJ <c-w>j
    nnoremap WK <c-w>k

    nnoremap WO :resize<cr>:vertical resize<cr>
    nnoremap WI :vertical resize<cr>
    nnoremap WU :resize<cr>
    nnoremap WW <c-w>w
    nnoremap WN <c-w>=
    nnoremap Wh 30<c-w><
    nnoremap Wl 30<c-w>>
    nnoremap Wj 10<c-w>+
    nnoremap Wk 10<c-w>-
    " fold
    xnoremap ZH zf
    nnoremap ZH zc
    nnoremap ZL zo
    nnoremap Zh zC
    nnoremap Zl zO
    nnoremap ZU zE
    nnoremap ZI zM
    nnoremap ZO zR
    " diff util
    nnoremap D <nop>
    nnoremap DJ ]czz
    nnoremap DK [czz
    nnoremap DH do
    nnoremap DL dp
    nnoremap DD :diffupdate<cr>
    " quick move lines
    nnoremap C <nop>

    if g:zf_fakevim!=1
        nnoremap CH v"txhh"tp
        nnoremap CL v"tx"tp
        nnoremap CJ mT:m+<cr>`T:delmarks T<cr>:echo ''<cr>
        nnoremap CK mT:m-2<cr>`T:delmarks T<cr>:echo ''<cr>

        xnoremap CH "txhh"tp`<hm<`>hm>gv
        xnoremap CL "tx"tp`<lm<`>lm>gv
        xnoremap CJ :m'>+<cr>gv
        xnoremap CK :m'<-2<cr>gv
    else
        nnoremap CH vxhhp
        nnoremap CL vxp
        nnoremap CJ :m+<cr>
        nnoremap CK :m-2<cr>

        vnoremap CH xhhp`<hm<`>hm>gv
        vnoremap CL xp`<lm<`>lm>gv
        vnoremap CJ :m'>+<cr>gv
        vnoremap CK :m'<-2<cr>gv
    endif

    nnoremap < <<
    nnoremap > >>
    " inc/dec numbers
    nnoremap CI <c-a>
    nnoremap CU <c-x>
    set nrformats+=alpha
    " macro spec
    function! ZF_Setting_VimMacroMap()
        nnoremap Q :call ZF_Setting_VimMacroBegin(0)<cr>
        nnoremap zQ :call ZF_Setting_VimMacroBegin(1)<cr>
        nnoremap cQ :let @t='let @m="' . @m . '"'<cr>q:"tgP
        nmap M @m
    endfunction
    function! ZF_Setting_VimMacroBegin(isAppend)
        nnoremap Q q:call ZF_Setting_VimMacroEnd()<cr>
        nnoremap M q:call ZF_Setting_VimMacroEnd()<cr>@m
        if a:isAppend!=1
            normal! qm
        else
            normal! qM
        endif
    endfunction
    function! ZF_Setting_VimMacroEnd()
        call ZF_Setting_VimMacroMap()
        echo 'macro recorded, use M in normal mode to repeat'
    endfunction
    if g:zf_fakevim!=1
        " mapping '::' would confuse some vim simulate plugins which would cause strange behavior,
        " even worse, some of them won't check 'if' statement and always apply settings inside the 'if',
        " here's some tricks (using autocmd) to completely prevent the mapping from being executed
        augroup ZF_Setting_VimMacro_augroup
            autocmd!
            autocmd User ZFVimrcPost
                        \ call ZF_Setting_VimMacroMap()|
                        \ nnoremap :: q:k$|
                        \ nnoremap // q/k$
        augroup END
    endif
    " quick edit command
    cnoremap <leader>ve <c-c>q:k$
    " search and replace
    " (here's a memo for regexp)
    "
    " zero width:
    "     (?=exp)  : anything end with exp (excluding exp)
    "     (?!exp)  : anything not end with exp
    "     (?<=exp) : anything start with exp (excluding exp)
    "     (?<!exp) : anything not start with exp
    "
    " match as less as possible:
    "     .*    : .*?
    "     .+    : .+?
    "     .{n,} : .{n,}?
    "
    " match line except contains zzz:
    "     ^(?!.*zzz).*$
    if g:zf_fakevim!=1
        nnoremap / /\v
        nnoremap ? /\v
        nnoremap <leader>vr :.,$s/\v/gec<left><left><left><left>
        xnoremap <leader>vr "ty:.,$s/\v<c-r>t//gec<left><left><left><left>
        nnoremap <leader>zr :.,$s/\v/gec<left><left><left><left><<c-r><c-w>>/
        xnoremap <leader>zr "ty:.,$s/\v<<c-r>t>//gec<left><left><left><left>

        nnoremap <leader>v/ :%s/\v//gn<left><left><left><left>
    else
        nnoremap / /
        nnoremap ? /
        nnoremap <leader>vr :.,$s//gec<left><left><left><left>
        vnoremap <leader>vr y:.,$s/<c-r>0//gec<left><left><left><left>
        nnoremap <leader>zr :.,$s//gec<left><left><left><left>\<<c-r><c-w>\>/
        vnoremap <leader>zr y:.,$s/\<<c-r>0\>//gec<left><left><left><left>

        nnoremap <leader>v/ :%s///gn<left><left><left><left>
    endif
    " suspend is not useful
    nnoremap <c-z> <nop>
endif " custom key mapping


" ==================================================
if 1 " common settings
    " common
    filetype plugin on
    syntax on
    set nocompatible
    set hidden
    set list
    set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
    set modeline
    set showcmd
    set showmatch
    set wildmenu
    set autoread
    set nobackup
    set nowritebackup
    set noswapfile
    set nowrap
    set synmaxcol=200
    set lazyredraw
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=R
    set guioptions-=l
    set guioptions-=L
    set guioptions-=b
    set clipboard+=unnamed
    set whichwrap=b,s,<,>,[,]
    set display=lastline
    set sessionoptions-=options
    function! ZF_Setting_common_action()
        set number
        set textwidth=0
        set iskeyword=@,48-57,_,128-167,224-235
    endfunction
    call ZF_Setting_common_action()
    augroup ZF_Setting_common_augroup
        autocmd!
        autocmd FileType,BufNewFile,BufReadPost * call ZF_Setting_common_action()
    augroup END
    augroup ZF_Setting_largefile_augroup
        autocmd!
        autocmd BufReadPre *
                    \ let f=expand('<afile>')|
                    \ if getfsize(f) > (1024 * 1024 * 5)|
                    \     set eventignore+=FileType|
                    \     setlocal bufhidden=unload|
                    \     setlocal foldmethod=manual|
                    \     setlocal nofoldenable|
                    \     setlocal nocursorline|
                    \     syntax clear|
                    \ endif
    augroup END
    " allow Alt mapping in terminal (imap still not work)
    if !has('nvim')
        augroup ZF_Setting_VimAltMap_augroup
            autocmd!
            autocmd User ZFVimrcPost
                        \ let c='a'|
                        \ while c <= 'z'|
                        \     execute "set <A-".c.">=\e".c|
                        \     execute "imap \e".c." <A-".c.">"|
                        \     let c = nr2char(1+char2nr(c))|
                        \ endwhile|
                        \ set ttimeout ttimeoutlen=50
        augroup END
    endif
    " encodings
    set fileformats=unix,dos
    set fileformat=unix
    set encoding=utf-8
    set termencoding=utf-8
    set fileencoding=utf-8
    set fileencodings=utf-8,ucs-bom,chinese
    " search
    set ignorecase
    set smartcase
    set hlsearch
    set incsearch
    let s:ZF_Setting_ToggleSearch_last=''
    function! ZF_Setting_ToggleSearch()
        if s:ZF_Setting_ToggleSearch_last == '' || s:ZF_Setting_ToggleSearch_last == @/
            let s:ZF_Setting_ToggleSearch_last=@/
            echo '' . s:ZF_Setting_ToggleSearch_last
            return
        endif

        echo 'choose search pattern:'
        echo '  j: ' . s:ZF_Setting_ToggleSearch_last
        echo '  k: ' . @/
        let confirm=nr2char(getchar())
        redraw!

        if confirm == 'j'
            let @/=s:ZF_Setting_ToggleSearch_last
            silent! normal! n
            echo '' . @/
        elseif confirm == 'k'
            let s:ZF_Setting_ToggleSearch_last=@/
            silent! normal! n
            echo '' . @/
        else
            echo 'canceled'
        endif
    endfunction
    nnoremap zb :call ZF_Setting_ToggleSearch()<cr>

    if g:zf_fakevim!=1
        nnoremap zn viw<esc>b/<c-r><c-w><cr>N
        xnoremap zn "ty/<c-r>t<cr>N
        nnoremap zm viw<esc>b/\<<c-r><c-w>\><cr>N
        xnoremap zm "ty/\<<c-r>t\><cr>N

        nnoremap z/n viw<esc>b:%s/<c-r><c-w>//gn<cr>``
        xnoremap z/n "ty:%s/<c-r>t//gn<cr>``
        nnoremap z/m viw<esc>b:%s/\<<c-r><c-w>\>//gn<cr>``
        xnoremap z/m "ty:%s/\<<c-r>t\>//gn<cr>``
    else
        nnoremap zn viwy/<c-r>0<cr>N
        xnoremap zn y/<c-r>0<cr>N
        nnoremap zm viwy/\<<c-r>0\><cr>N
        xnoremap zm y/\<<c-r>0\><cr>N

        nnoremap z/n viwy:%s/<c-r>0//gn<cr>``
        xnoremap z/n y:%s/<c-r>0//gn<cr>``
        nnoremap z/m viwy:%s/\<<c-r>0\>//gn<cr>``
        xnoremap z/m y:%s/\<<c-r>0\>//gn<cr>``
    endif
    " tab and indent
    set expandtab
    set shiftwidth=4
    set softtabstop=0
    set tabstop=4
    set smartindent
    set cindent
    set autoindent
    set cinkeys=0{,0},0),:,!^F,o,O,e
    " editing
    set virtualedit=onemore,block
    set selection=exclusive
    set guicursor=a:block-blinkon0
    set backspace=indent,eol,start
    set scrolloff=5
    set sidescrolloff=5
    set selectmode=key
    set mouse=
    " wildignore
    function! ZF_Setting_wildignore()
        for item in g:zf_exclude_all_expand
            execute 'set wildignore+=' . item
        endfor
    endfunction
    call ZF_Setting_wildignore()
    augroup ZF_Setting_wildignore_augroup
        autocmd!
        autocmd User ZFExcludeChanged call ZF_Setting_wildignore()
    augroup END
    " disable italic fonts
    function! ZF_Setting_DisableItalic()
        let his = ''
        redir => his
        silent highlight
        redir END
        let his = substitute(his, '\n\s\+', ' ', 'g')
        for line in split(his, "\n")
            if line !~ ' links to ' && line !~ ' cleared$'
                execute 'hi' substitute(substitute(line, ' xxx ', ' ', ''), 'italic', 'none', 'g')
            endif
        endfor
    endfunction
    silent! call ZF_Setting_DisableItalic()
    augroup ZF_Setting_DisableItalic_augroup
        autocmd!
        autocmd FileType,BufNewFile,BufReadPost * silent! call ZF_Setting_DisableItalic()
    augroup END
    " status line
    set laststatus=2
    set statusline-=%<%f
    set statusline+=%<%f
    set statusline-=\ %m%r
    set statusline+=\ %m%r
    set statusline-=%=%k
    set statusline+=%=%k
    set statusline-=\ %l/%L\ :\ %c
    set statusline+=\ %l/%L\ :\ %c
    set statusline-=\ \ \ %y
    set statusline+=\ \ \ %y
    set statusline-=\ [%{(&bomb?\",BOM\ \":\"\")}%{(&fenc==\"\")?&enc:&fenc}\ %{(&fileformat)}]
    set statusline+=\ [%{(&bomb?\",BOM\ \":\"\")}%{(&fenc==\"\")?&enc:&fenc}\ %{(&fileformat)}]
    set statusline-=\ %4b
    set statusline+=\ %4b
    set statusline-=\ %04B
    set statusline+=\ %04B
    set statusline-=\ %3p%%
    set statusline+=\ %3p%%
    augroup ZF_Setting_quickfix_statusline_augroup
        autocmd!
        autocmd BufWinEnter quickfix,qf
                    \ setlocal statusline=%<%t\ %=%k\ %l/%L\ :\ %c\ %4b\ %04B\ %3p%%
    augroup END
    " cursorline
    set linespace=2
    if 0 " cursorline is quite slow
        set cursorline
    endif
    highlight Cursor gui=NONE guibg=green guifg=black
    highlight Cursor cterm=NONE ctermbg=green ctermfg=black
    highlight CursorLine gui=underline guibg=NONE guifg=NONE
    highlight CursorLine cterm=bold ctermbg=NONE ctermfg=NONE
    highlight CursorLineNr gui=reverse guibg=NONE guifg=NONE
    highlight CursorLineNr cterm=reverse ctermbg=NONE ctermfg=NONE
    " complete
    if g:zf_fakevim!=1
        inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-g>u\<cr>"
        inoremap <expr> <c-p> pumvisible() ? '<c-p>' : '<c-p><c-r>=pumvisible() ? "\<lt>Up>" : ""<cr>'
        inoremap <expr> <c-n> pumvisible() ? '<c-n>' : '<c-n><c-r>=pumvisible() ? "\<lt>Down>" : ""<cr>'
        inoremap <expr> <c-k> pumvisible() ? '<c-p>' : '<up>'
        inoremap <expr> <c-j> pumvisible() ? '<c-n>' : '<down>'
    else
        iunmap <cr>
        iunmap <c-p>
        iunmap <c-n>
        iunmap <c-k>
        iunmap <c-j>
    endif
    set completeopt=menuone,longest
    set complete=.,w,b,u,k,t
    set omnifunc=syntaxcomplete#Complete
    " fold
    function! ZF_Setting_fold_action()
        set foldminlines=0
        set foldlevel=128
        set foldmethod=manual
        normal! zE
    endfunction
    call ZF_Setting_fold_action()
    augroup ZF_Setting_fold_augroup
        autocmd!
        autocmd FileType,BufNewFile,BufReadPost * call ZF_Setting_fold_action()
    augroup END
    " diff
    set diffopt=filler,context:200
    " q
    if g:zf_fakevim!=1
        nnoremap q <esc>
        xnoremap q <esc>
        onoremap q <esc>
    else
        noremap q <esc>
    endif
    augroup ZF_Setting_qToEsc_augroup
        autocmd!
        autocmd CmdwinEnter *
                    \ nnoremap <buffer> <silent> q :q<cr>
        autocmd BufWinEnter quickfix,qf
                    \ nnoremap <buffer> <silent> q :bd<cr>|
                    \ nnoremap <buffer> <silent> <leader>vt :bd<cr>|
                    \ nnoremap <buffer> <silent> <cr> <cr>:lclose<cr>|
                    \ nnoremap <buffer> <silent> o <cr>:lclose<cr>|
                    \ setlocal foldmethod=indent
        autocmd FileType help
                    \ nnoremap <buffer> <silent> q :q<cr>
    augroup END
endif " common settings


" ==================================================
if 1 " custom themes
    highlight Folded gui=NONE guibg=NONE guifg=DarkBlue
    highlight Folded cterm=NONE ctermbg=NONE ctermfg=DarkBlue
    highlight IncSearch ctermbg=White ctermfg=Red
    highlight IncSearch guibg=White guifg=Red
    highlight MatchParen ctermbg=DarkBlue ctermfg=Red
    highlight MatchParen guibg=DarkBlue guifg=Red
    highlight NonText ctermbg=NONE ctermfg=DarkRed
    highlight NonText guibg=NONE guifg=DarkRed
    highlight Pmenu gui=NONE guibg=Gray guifg=Black
    highlight Pmenu cterm=NONE ctermbg=Gray ctermfg=Black
    highlight PmenuSel gui=bold guibg=LightGreen guifg=Red
    highlight PmenuSel cterm=bold ctermbg=LightGreen ctermfg=Red
    highlight PmenuSbar gui=bold guibg=DarkGreen guifg=Red
    highlight PmenuSbar cterm=bold ctermbg=DarkGreen ctermfg=Red
    highlight PmenuThumb gui=NONE guibg=LightGreen guifg=Red
    highlight PmenuThumb cterm=NONE ctermbg=LightGreen ctermfg=Red
    highlight SpecialKey ctermbg=NONE ctermfg=DarkRed
    highlight SpecialKey guibg=NONE guifg=DarkRed

    highlight ZFColor_TabInactive gui=bold guibg=White guifg=Black
    highlight ZFColor_TabInactive cterm=bold ctermbg=White ctermfg=Black
    highlight ZFColor_TabInactiveModified gui=bold guibg=White guifg=Red
    highlight ZFColor_TabInactiveModified cterm=bold ctermbg=White ctermfg=Red
    highlight ZFColor_TabActive gui=bold guibg=LightGreen guifg=Black
    highlight ZFColor_TabActive cterm=bold ctermbg=LightGreen ctermfg=Black
    highlight ZFColor_TabActiveModified gui=bold guibg=LightGreen guifg=Red
    highlight ZFColor_TabActiveModified cterm=bold ctermbg=LightGreen ctermfg=Red
endif " plugin themes


" ==================================================
" tutorial
if 1
    nnoremap z? :call ZFVimrcGuide()<cr>
    function! ZFVimrcGuide()
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader> is single quote', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vimru to update this vimrc with github repo', 'command':'call ZF_VimrcUpdate()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'key mappings', 'command':'call ZFVimrcGuide_keymap()', 'itemType':'subMenu'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'window and buffer management', 'command':'call ZFVimrcGuide_window()', 'itemType':'subMenu'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'tools', 'command':'call ZFVimrcGuide_tools()', 'itemType':'subMenu'})
        call ZF_VimCmdMenuShow({'headerText':'zf_vimrc quick tutorial:'})
    endfunction

    function! ZFVimrcGuide_keymap()
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'? for search with perl regexp syntax', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'s/S for quick cursor jump', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'Q to record macro and M to replay macro', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':':: or // to open command/search history, q to exit', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'EH/EL/EJ/EK/EI for cursor jump by indent', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'z)/z]/z} for cursor jump by brace', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'t/T for select within quotes', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'ZB to open fold utility', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'Z)/Z]/Z}/Z> to fold by brace', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'ZH/ZL/ZI/ZO/ZU for manual fold', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'zn/zm/<leader>vr/<leader>zr for quick search and replace', 'itemType':'keep'})
        call ZF_VimCmdMenuShow({'headerText':'key mappings:'})
    endfunction

    function! ZFVimrcGuide_window()
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<c-o> to open files by file name (fuzzy search)', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'H/L to switch to prev/next buffer', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'WH/WL/WJ/WK to jump between windows', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'Wh/Wl/Wj/Wk/WN to resize windows', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'x to close current buffer', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'X to close all buffer except current one', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>ve to open file explorer (NERDTree)', 'command':'NERDTreeToggle'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vt to open tag list', 'command':'TagbarToggle'})
        call ZF_VimCmdMenuShow({'headerText':'window and buffer management:'})
    endfunction

    function! ZFVimrcGuide_tools()
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vgf / <leader>vgr to grep/replace (with perl regexp syntax)', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vs / <leader>vc to run shell/vim command and copy result to clipboard', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vvs / <leader>vvc to run shell/vim command in clipboard and copy result to clipboard', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vvo to open all file in clipboard', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>vdb / <leader>vdf to diff two buffer/file', 'itemType':'keep'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>cc to open convert utility', 'command':'call ZF_Convert()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>ce to open escape utility', 'command':'call ZF_VimEscape()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>cf to open formater utility', 'command':'call ZF_Formater()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>cm to open toggle utility', 'command':'call ZF_Toggle()'})
        call ZF_VimCmdMenuAdd({'showKeyHint':1, 'text':'<leader>cth toggle plain txt highlight', 'command':'call ZF_VimTxtHighlightToggle()'})
        call ZF_VimCmdMenuShow({'headerText':'tools:'})
    endfunction
endif


" ==================================================
if 1 " local env setting
    if g:zf_windows==1
        " use cmd.exe for most compatibility
        set shell=cmd.exe
        " have shellslash for convenient when editing code,
        " may break something while using other plugins,
        " disable it manually if need
        set shellslash
        " ensure cygwin at head of PATH,
        " otherwise some Windows' shell function may break cygwin's command,
        " such as 'find'
        let $PATH='C:\cygwin\bin;' . $PATH

        function! ZF_Windows_WindowCenterInScreen()
            set lines=9999 columns=9999
            let linesTmp=&lines
            let columnsTmp=&columns
            let sizeFixX=58
            let sizeFixY=118
            let scaleX=7.75
            let scaleY=17.0
            let screenWidth=float2nr(winwidth(0) * scaleX) + getwinposx() + sizeFixX
            let screenHeight=float2nr(winheight(0) * scaleY) + getwinposy() + sizeFixY
            if linesTmp <= 45 || columnsTmp <= 160
                set lines=35 columns=120
            else
                set lines=45 columns=160
            endif
            let sizeWidth=float2nr(winwidth(0) * scaleX) + sizeFixX
            let sizeHeight=float2nr(winheight(0) * scaleY) + sizeFixY
            let posX=((screenWidth - sizeWidth) / 2)
            let posY=((screenHeight - sizeHeight) / 2)
            execute ':winpos ' . posX . ' ' . posY
        endfunction
        augroup ZF_Windows_WindowCenterInScreen_augroup
            autocmd!
            autocmd GUIEnter * call ZF_Windows_WindowCenterInScreen()
        augroup END
    endif
endif " local env setting

" ==================================================
" final setup
augroup ZF_VimrcPost_augroup
    autocmd!
    autocmd VimEnter * doautocmd User ZFVimrcPost
augroup END

