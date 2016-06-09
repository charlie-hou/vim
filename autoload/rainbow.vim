" rainbow.vim: Please see plugin/rainbow.vim

" Make sure line-continuations won't cause any problem. This will be restored
"   at the end
let s:save_cpo = &cpo
set cpo&vim

" Plugin script variables {{{
let s:guifgs = exists('g:rainbow_guifgs') ? g:rainbow_guifgs : [
            \ 'DarkOrchid3',
            \ 'RoyalBlue3',
            \ 'SeaGreen3',
            \ 'DarkOrange3',
            \ 'FireBrick',
            \ ]

let s:ctermfgs = exists('g:rainbow_ctermfgs')? g:rainbow_ctermfgs : [
            \ 'darkgray',
            \ 'Darkblue',
            \ 'darkmagenta',
            \ 'darkcyan',
            \ 'darkred',
            \ 'darkgreen',
            \ ]

let s:max = has('gui_running')? len(s:guifgs) : len(s:ctermfgs)

" A dictionary of filetypes and their respective parenthese regionpatterns
let s:ftpairs = exists('g:rainbow_filetype_matchpairs')? g:rainbow_filetype_matchpairs : {
            \     '*'     : [['(', ')'], ['\[', '\]'], ['{', '}']]
            \ }

" A dictionary of filetypes and their respective parenthese regionpatterns
let s:ftops = exists('g:rainbow_filetype_operators')? g:rainbow_filetype_operators : {
            \     '*'     : ['-', '+', '*', '/', '%', '<', '>' , '&', '|', '=', ',']
            \ }

" The name of the syntax region group, used in the syntax command, defining the parenthese region pattern
let s:ogroup = exists('g:rainbow_ogroup') ? g:rainbow_ogroup : 'RainbowOperator'

" The name of the syntax region group, used in the syntax command, defining the parenthese region pattern
let s:sgroup = exists('g:rainbow_sgroup') ? g:rainbow_sgroup :'RainbowSyntax'

" The name of the highlight group, used in the highlight command, defining the color selection
let s:hgroup = exists('g:rainbow_hgroup') ? g:rainbow_hgroup : 'RainbowHighlight'
" }}}

" Syntax Region Function {{{

" Load Syntax Groups - Creates the Syntax Regions based on the list of match pairs
func rainbow#loadsyntaxgroups(matchpairs, operators)
	if !empty(a:operators)
		let opercmd = 'syn match %s "[' . join(a:operators, '') . ']\{1,2}" containedin=%s contained'
		for id in range(1, s:max)
			exe printf(opercmd, s:ogroup.id, s:sgroup.id)
		endfor
	endif

    let paircmd = 'syn region %s matchgroup=%s start=+%s+ end=+%s+ containedin=%s contains=TOP,' . join(map(range(1, s:max), 's:sgroup . v:val'), ',') . ',%s'
    for [left , right] in a:matchpairs
        for id in range(1, s:max)
            exe printf(paircmd, s:sgroup.id, s:hgroup.id, left, right, id < s:max ? s:sgroup.(id+1) : s:sgroup."1", s:ogroup.id)
        endfor
    endfor
endfunc 

" Clear Syntax Groups - Clears all syntax regions created by this plugin
func rainbow#clearsyntaxgroups()
    for id in range(1, s:max)
        exe 'syn clear '.s:sgroup.id
        exe 'syn clear '.s:ogroup.id
    endfor
endfunc

" Clear Syntax Group - Clears a single syntax region created by this plugin
func rainbow#clearsyntaxgroup(group)
    for id in range(1, s:max)
        exe 'syn clear '.a:group.id
        exe 'syn clear '.a:group.id
    endfor
endfunc
"}}}

" Current buffer manipulation {{{

" Insert Match Pair - Inserts a matchpair into the buffer's current collection of matchpairs and reload the syntax regions
func rainbow#insertmatchpairs(...)
    if !exists('b:rainbow_matchpairs')
        let b:rainbow_matchpairs = []
    else
        call rainbow#clearsyntaxgroups()
    endif

    call insert(b:rainbow_matchpairs, a:000)
    call rainbow#loadsyntaxgroups(b:rainbow_matchpairs, exists('b:rainbow_operators') ? b:rainbow_operators : [])
endfunc

" Remove Match Pairs - Removes a matchpair from the buffer's current collection of matchpairs and reloads the syntax region
func rainbow#removematchpairs(...)
    if exists('b:rainbow_matchpairs')
        call rainbow#clearsyntaxgroups()
        call filter(b:rainbow_matchpairs, 'v:val != a:000')
        if empty(b:rainbow_matchpairs)
            unlet b:rainbow_matchpairs
        else
            call rainbow#loadsyntaxgroups(b:rainbow_matchpairs, exists('b:rainbow_operators') ? b:rainbow_operators : [])
        endif
    endif
endfunc

" Insert Operator - Inserts an operator into the buffer's current collection of operators and reload the syntax regions
func rainbow#insertoperators(...)
    if !exists('b:rainbow_operators')
        let b:rainbow_matchpairs = []
    else
        call rainbow#clearsyntaxgroups()
    endif

    call extend(b:rainbow_operators, a:000)
    call rainbow#loadsyntaxgroups(exists('b:rainbow_matchpairs') ? b:rainbow_matchpairs : [], b:rainbow_operators)
endfunc

" Remove Operator - Removes an operator from the buffer's current collection of operators and reloads the syntax region
func rainbow#removeoperators(...)
    if exists('b:rainbow_operators')
        call rainbow#clearsyntaxgroups()
		for operator in a:000
			call remove(b:rainbow_operators, index(b:rainbow_operators, operator))
		endfor
        if empty(b:rainbow_operators)
            unlet b:rainbow_operators
        else
			call rainbow#loadsyntaxgroups(exists('b:rainbow_matchpairs') ? b:rainbow_matchpairs : [], b:rainbow_operators)
        endif
    endif
endfunc

" Load Match Pairs from File Type - Loads the syntax region from the matchpairs associated with a filetype
func rainbow#loadmatchpairsforfiletype(ft)
    let key = get(filter(keys(s:ftpairs), 'v:val =~ ''\<'.a:ft.'\>'''), 0, '*')
    call rainbow#loadmatchpairs( 
				\ has_key(s:ftpairs, l:key) ? s:ftpairs[l:key] : [], 
				\ has_key(s:ftops, l:key) ? s:ftops[l:key] : []
				\ )	
endfunc

" Load Match Pair - Load the syntax region from the matchpairs
func rainbow#loadmatchpairs(matchpairs, operators)
    if exists('b:rainbow_matchpairs') || exists('b:rainbow_operators')
        call rainbow#clearsyntaxgroups()
    endif

    if empty(a:matchpairs)
        unlet! b:rainbow_matchpairs
        unlet! b:rainbow_operators
    else
        let b:rainbow_matchpairs = a:matchpairs
        let b:rainbow_operators  = a:operators
        call rainbow#loadsyntaxgroups(b:rainbow_matchpairs, b:rainbow_operators)
    endif
endfunc
"}}}

" Activation Functions {{{

" Activate - creates the highlight groups referenced by the syntax regions
func rainbow#activate()
    for id in range(1 , s:max)
        let ctermfg = s:ctermfgs[(s:max - id) % len(s:ctermfgs)]
        let guifg   = s:guifgs[(s:max - id) % len(s:guifgs)]
        exe 'hi default '.s:hgroup.id.' ctermfg='.ctermfg.' guifg='.guifg
        exe 'hi default '.s:ogroup.id.' ctermfg='.ctermfg.' guifg='.guifg
    endfor
    let g:rainbow_active = 1

    if !empty(s:ftpairs)
        augroup RainbowParenthesis
            au!
            if has_key(s:ftpairs, '*')
                auto syntax * call rainbow#loadmatchpairsforfiletype(&ft)
            else
                for ft in keys(s:ftpairs)
                    exe 'auto syntax'. ft . ' call rainbow#loadmatchpairs('. string(s:ftpairs[ft]) .')'
                endfor
            endif
        augroup END
    endif
endfunc

" Inactivate - Destroyes the highlight groups referenced by the syntax regions
func rainbow#deactivate()
    if exists('g:rainbow_active')
        for id in range(1, s:max)
            exe 'hi clear '.s:hgroup.id
            exe 'hi clear '.s:ogroup.id
        endfor
        unlet g:rainbow_active
    endif

    augroup! RainbowParenthesis
endfunc

" Activates/Deactivates the Rainbow Parenthesis
func rainbow#toggle()
    if exists('g:rainbow_active')
        call rainbow#deactivate()
    else
        " If no matchpair definition exists, try loading from the filetype
        let origin = bufnr("%")
        for b in filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(getbufvar(v:val, "rainbow_matchpairs"))')
            exe "buffer ". b
			if !exists("b:rainbow_matchpairs")
				call rainbow#loadmatchpairsforfiletype(&ft)
			endif
        endfor
        exe "buffer ". l:origin
        call rainbow#activate()
    endif
endfunc
"}}}

" Restore cpo.
let &cpo = s:save_cpo
unlet s:save_cpo

" vim: fdm=marker:noet:ts=4:sw=4:sts=4
