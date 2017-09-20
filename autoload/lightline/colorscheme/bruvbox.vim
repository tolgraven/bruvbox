" -----------------------------------------------------------------------------
" File: bruvbox.vim
" Description: Gruvbox colorscheme for Lightline (itchyny/lightline.vim)
" Author: gmoe <me@griffinmoe.com>
" Source: https://github.com/tolgraven/bruvbox
" Last Modified: 31 Oct 2015
" -----------------------------------------------------------------------------

function! s:getGruvColor(group)
  let guiColor = synIDattr(hlID(a:group), "fg", "gui") 
  let termColor = synIDattr(hlID(a:group), "fg", "cterm") 
  return [ guiColor, termColor ]
endfunction

if exists('g:lightline')

  let s:bg0  = s:getGruvColor('BruvboxBg0')
  let s:bg1  = s:getGruvColor('BruvboxBg1')
  let s:bg2  = s:getGruvColor('BruvboxBg2')
  let s:bg4  = s:getGruvColor('BruvboxBg4')
  let s:fg1  = s:getGruvColor('BruvboxFg1')
  let s:fg4  = s:getGruvColor('BruvboxFg4')

  let s:yellow = s:getGruvColor('BruvboxYellow')
  let s:blue   = s:getGruvColor('BruvboxBlue')
  let s:aqua   = s:getGruvColor('BruvboxAqua')
  let s:orange = s:getGruvColor('BruvboxOrange')

  let s:p = {'normal':{}, 'inactive':{}, 'insert':{}, 'replace':{}, 'visual':{}, 'tabline':{}}
  let s:p.normal.left = [ [ s:bg0, s:fg4 ], [ s:fg4, s:bg2 ] ]
  let s:p.normal.right = [ [ s:bg0, s:fg4 ], [ s:fg4, s:bg2 ] ]
  let s:p.normal.middle = [ [ s:fg4, s:bg1 ] ]
  let s:p.inactive.right = [ [ s:bg4, s:bg1 ], [ s:bg4, s:bg1 ] ]
  let s:p.inactive.left =  [ [ s:bg4, s:bg1 ], [ s:bg4, s:bg1 ] ]
  let s:p.inactive.middle = [ [ s:bg4, s:bg1 ] ]
  let s:p.insert.left = [ [ s:bg0, s:blue ], [ s:fg1, s:bg2 ] ]
  let s:p.insert.right = [ [ s:bg0, s:blue ], [ s:fg1, s:bg2 ] ]
  let s:p.insert.middle = [ [ s:fg4, s:bg2 ] ]
  let s:p.replace.left = [ [ s:bg0, s:aqua ], [ s:fg1, s:bg2 ] ]
  let s:p.replace.right = [ [ s:bg0, s:aqua ], [ s:fg1, s:bg2 ] ]
  let s:p.replace.middle = [ [ s:fg4, s:bg2 ] ]
  let s:p.visual.left = [ [ s:bg0, s:orange ], [ s:bg0, s:bg4 ] ]
  let s:p.visual.right = [ [ s:bg0, s:orange ], [ s:bg0, s:bg4 ] ]
  let s:p.visual.middle = [ [ s:fg4, s:bg1 ] ]
  let s:p.tabline.left = [ [ s:fg4, s:bg2 ] ]
  let s:p.tabline.tabsel = [ [ s:bg0, s:fg4 ] ]
  let s:p.tabline.middle = [ [ s:bg0, s:bg0 ] ]
  let s:p.tabline.right = [ [ s:bg0, s:orange ] ]
  let s:p.normal.error = [ [ s:bg0, s:orange ] ]
  let s:p.normal.warning = [ [ s:bg2, s:yellow ] ]

  let g:lightline#colorscheme#gruvbox#palette = lightline#colorscheme#flatten(s:p)
endif
