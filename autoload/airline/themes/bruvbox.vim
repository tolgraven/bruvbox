" -----------------------------------------------------------------------------
" File: autoload/airline/themes/bruvbox.vim
" Description: badman groove riddim
" Author: @tolgraven
" Source: https://github.com/tolgraven/bruvbox
" Last Modified: Apr 2017
" -----------------------------------------------------------------------------

let s:p = {}

function! airline#themes#bruvbox#refresh() abort
  if !get(g:, 'loaded_airline', 0) | return | endif

  let M0        = airline#themes#get_highlight('BruvboxOrangeSpecial')
  " let accents   = airline#themes#get_highlight('Special')
  let modified  = ['', M0[0], M0[2], '', '']
  let s:modified_reverse = airline#themes#get_highlight2(['BruvboxOrangeSpecial','fg'],  ['BruvboxBg0',     'fg'])
  let warning   = airline#themes#get_highlight2(['Normal',       'bg'],  ['WarningMsg', 'fg'])    "bit hacky since I'm running those non-inverted, maybe not very standard
  let warning_reverse = airline#themes#get_highlight2(['WarningMsg','fg'],  ['BruvboxBg0',     'fg'])
  let error     = airline#themes#get_highlight2(['BruvboxBg0',    'fg'],  ['ErrorMsg',   'fg'])   "(['Normal', 'fg'], ['WarningMsg', 'fg'])
  "no way to set default for all modes??
  " let s:p.airline_warning                   = warning
  " " let s:p.airline_warning                   = warning
  " let s:p.airline_error                     = error
  " " let s:p.airline_error                     = error
  " Normal:
  " let s:N1 = airline#themes#get_highlight2(['Normal',                'fg'],  ['StatusLineNC', 'bg']) " section a, mode indicator. Updated to use Normal _fg_ not bg
  let s:N1 = airline#themes#get_highlight2(['BruvboxNormalModeColor', 'fg'],  ['BruvboxBg0_h',          'fg']) " section a, mode indicator. Updated to use Normal _fg_ not bg
  let s:N2 = airline#themes#get_highlight2(['BruvboxBg0', 'fg'],  ['BruvboxBlueSpecial',    'fg']) " section b, git shite
  let s:N3 = airline#themes#get_highlight2(['BruvboxBg0_m', 'fg'],  ['BruvboxBrightGray',     'fg']) " section c, so fg = buffer/file name, if unedited
  let s:p.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)                  "{{{
  let s:p.normal_modified                   = { 'airline_c': modified }
  let s:p.normal.airline_warning            = warning
  let s:p.normal_modified.airline_warning   = warning
  let s:p.normal.airline_error              = error
  let s:p.normal_modified.airline_error     = error                               "}}}
  " Insert:
  " let s:I1 = airline#themes#get_highlight2(['Normal',            'bg'],  ['Identifier',   'fg'])
  let s:I1 = airline#themes#get_highlight2(['BruvboxInsertModeColor',   'fg'],  ['BruvboxBg0_h',            'fg'])
  " let s:I3 = airline#themes#get_highlight2(['BruvboxBrightGray', 'fg'],  ['StatusLineNC', 'fg'])
  let s:I3 = airline#themes#get_highlight2(['BruvboxInsertModeColor', 'bg'],  ['BruvboxBrightGray', 'fg']) "eh how is bg (colorcolumn) getting red?
  " let s:I3 = airline#themes#get_highlight2(['BruvboxBg0_h', 'fg'],  ['BruvboxInsertModeColor', 'bg']) "eh how is bg (colorcolumn) getting red?
  let s:p.insert = airline#themes#generate_color_map(s:I1, s:N2, s:I3) "git section stays the same across all {{{
  let s:p.insert_modified                   = s:p.normal_modified
  let s:p.insert.airline_warning            = warning
  let s:p.insert_modified.airline_warning   = warning
  let s:p.insert.airline_error              = error
  let s:p.insert_modified.airline_error     = error                               "}}}
  " Replace:
  let s:R1 = airline#themes#get_highlight2(['Structure',    'fg'],          ['Normal',    'bg'])
  " let s:R3 = airline#themes#get_highlight2(['Normal',    'fg'],          ['BruvboxBg2_h', 'fg'])
  let s:R3 = airline#themes#get_highlight2(['BruvboxBg2_h', 'fg'],          ['BruvboxBrightGray', 'fg'])
  let s:p.replace = airline#themes#generate_color_map(s:R1, s:N2, s:R3)                 "{{{
  let s:p.replace_modified                  = s:p.normal_modified
  let s:p.replace.airline_warning           = warning
  let s:p.replace_modified.airline_warning  = warning
  let s:p.replace.airline_error             = error
  let s:p.replace_modified.airline_error    = error                               "}}}
  " Visual:
  let s:V1 = airline#themes#get_highlight2(['BruvboxVisualModeColor', 'fg'],         ['Normal',     'fg'])
  let s:p.visual = airline#themes#generate_color_map(s:V1, s:N2, s:R3)                  "{{{
  let s:p.visual_modified = { 'airline_c': [ s:R3[0], '', s:R3[2], '', '' ] }
  let s:p.visual.airline_warning            = warning
  let s:p.visual_modified.airline_warning   = warning
  let s:p.visual.airline_error              = error
  let s:p.visual_modified.airline_error     = error                               "}}}

  " Inactive:
  let s:IA1 = airline#themes#get_highlight2(['BruvboxBg0', 'fg'],       ['TabLine',     'fg'])
  let s:IA2 = airline#themes#get_highlight2(['TabLineFill', 'bg'],       ['BruvboxBg4',  'fg'])
  let s:IA3 = airline#themes#get_highlight2(['TabLineFill', 'bg'],       ['TabLine',     'fg'])
  let s:p.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
  let s:p.inactive_modified                 = { 'airline_c': modified }

  let s:TF = airline#themes#get_highlight2(['TabLineFill',  'bg'],       ['Normal',       'bg'])
  let s:p.tabline = {
    \ 'airline_tab':      airline#themes#get_highlight('TabLine'),
    \ 'airline_tabsel':   s:N1,
    \ 'airline_tabtype':  s:V1,
    \ 'airline_tabfill':  s:TF,
    \ 'airline_tabhid':   s:IA1,
    \ 'airline_tabmod':   M0,
    \ } "s:modified_reverse
    " \ 'airline_tabmod':   airline#themes#get_highlight2(['BruvboxBg3',   'fg'],  ['BruvboxGreenBg',    'bg'])
    " \ 'airline_tabmod':   airline#themes#get_highlight('BruvboxGreen')

  let s:green   = airline#themes#get_highlight('BruvboxGreen')
  let s:green   = ['', s:green[0], '', s:green[2], '']
  let s:yellow  = airline#themes#get_highlight('BruvboxYellow')
  let s:yellow   = ['', s:yellow[0], '', s:yellow[2], '']
  let s:red     = airline#themes#get_highlight('BruvboxRed')
  let s:red   = ['', s:red[0], '', s:red[2], '']
  let s:purple  = airline#themes#get_highlight('BruvboxPurple')
  let s:purple   = ['', s:purple[0], '', s:purple[2], '']
  let s:blue    = airline#themes#get_highlight('BruvboxBlue')
  let s:blue   = ['', s:blue[0], '', s:blue[2], '']
  let s:aqua    = airline#themes#get_highlight('BruvboxAqua')
  let s:aqua   = ['', s:aqua[0], '', s:aqua[2], '']
  let s:orange  = airline#themes#get_highlight('BruvboxOrange')
  let s:orange   = ['', s:orange[0], '', s:orange[2], '']
  let s:p.accents = { 'green': s:green, 'yellow': s:yellow, 'red': s:red, 'purple': s:purple, 'blue': s:blue, 'aqua': s:aqua, 'orange': s:orange }

endfunction

let g:airline#themes#bruvbox#palette = s:p
call airline#themes#bruvbox#refresh()

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
