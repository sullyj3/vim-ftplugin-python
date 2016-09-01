" Vim filetype plugin file
" Language:	python
" Maintainer:	James Sully <sullyj3@gmail.com>
" Previous Maintainer: Johannes Zellner <johannes@zellner.org>
" Last Change:	Fri, 02 September 2016
" https://github.com/sullyj3/vim-ftplugin-python

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1
let s:keepcpo= &cpo
set cpo&vim

setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal include=^\\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.py
setlocal comments=b:#,fb:-
setlocal commentstring=#\ %s

setlocal omnifunc=pythoncomplete#Complete

set wildignore+=*.pyc

noremap <silent> <buffer> ]] :call <SID>Python_jump('n', '\v%$\|^(class\|def)>', 'W')<cr>
noremap <silent> <buffer> [[ :call <SID>Python_jump('n', '\v^(class\|def)>', 'Wb')<cr>
noremap <silent> <buffer> ]m :call <SID>Python_jump('n', '\v%$\|^\s*(class\|def)>', 'W')<cr>
noremap <silent> <buffer> [m :call <SID>Python_jump('n', '\v^\s*(class\|def)>', 'Wb')<cr>

" override for select & visual modes, since we will need to preserve the selection
xnoremap <silent> <buffer> ]] :call <SID>Python_jump('x', '\v%$\|^(class\|def)>', 'W')<cr>
xnoremap <silent> <buffer> [[ :call <SID>Python_jump('x', '\v^(class\|def)>', 'Wb')<cr>
xnoremap <silent> <buffer> ]m :call <SID>Python_jump('x', '\v%$\|^\s*(class\|def)>', 'W')<cr>
xnoremap <silent> <buffer> [m :call <SID>Python_jump('x', '\v^\s*(class\|def)>', 'Wb')<cr>

if !exists('*<SID>Python_jump')
  fun! <SID>Python_jump(mode, motion, flags) range
      if a:mode == 'x'
          normal! gv
      endif

      normal! 0

      let cnt = v:count1
      mark '
      while cnt > 0
          call search(a:motion, a:flags)
          let cnt = cnt - 1
      endwhile

      normal! ^
  endfun
endif

if has("browsefilter") && !exists("b:browsefilter")
    let b:browsefilter = "Python Files (*.py)\t*.py\n" .
                \ "All Files (*.*)\t*.*\n"
endif

" As suggested by PEP8.
setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=8

" First time: try finding "pydoc".
if !exists('g:pydoc_executable')
    if executable('pydoc')
        let g:pydoc_executable = 1
    else
        let g:pydoc_executable = 0
    endif
endif
" If "pydoc" was found use it for keywordprg.
if g:pydoc_executable
    setlocal keywordprg=pydoc
endif

let &cpo = s:keepcpo
unlet s:keepcpo
