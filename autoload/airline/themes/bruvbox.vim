" -----------------------------------------------------------------------------
" File: autoload/airline/themes/bruvbox.vim
" Description: badman groove riddim
" Author: @tolgraven
" Source: https://github.com/tolgraven/bruvbox
" Last Modified: Apr 2017
" -----------------------------------------------------------------------------

let s:palette = {}

function! airline#themes#bruvbox#refresh()

  let M0              = airline#themes#get_highlight('BruvboxOrangeSpecial')
  let accents_group   = airline#themes#get_highlight('Special')
  let modified_group  = [M0[0], '', M0[2], '', '']
  let warning_group   = airline#themes#get_highlight2(['WarningMsg', 'fg'],  ['Normal',       'bg'])    "bit hacky since I'm running those non-inverted, maybe not very standard
  " let warning_reverse = airline#themes#get_highlight2(['Normal',     'bg'],  ['WarningMsg',   'fg'])
  let warning_reverse = airline#themes#get_highlight2(['BruvboxBg0',     'fg'],  ['WarningMsg','fg'])
  let error_group     = airline#themes#get_highlight2(['ErrorMsg',   'fg'],  ['BruvboxBg0',    'fg'])   "(['Normal', 'fg'], ['WarningMsg', 'fg'])
  " Normal:
  " let s:N1 = airline#themes#get_highlight2(['Normal',                'fg'],  ['StatusLineNC', 'bg']) " section a, mode indicator. Updated to use Normal _fg_ not bg
  let s:N1 = airline#themes#get_highlight2(['BruvboxBg0_h',          'fg'],  ['StatusLineNC', 'bg']) " section a, mode indicator. Updated to use Normal _fg_ not bg
  let s:N2 = airline#themes#get_highlight2(['BruvboxBlueSpecial',    'fg'],  ['BruvboxBg0', 'fg']) " section b, git shite
  let s:N3 = airline#themes#get_highlight2(['BruvboxBrightGray',     'fg'],  ['BruvboxBg0_m', 'fg']) " section c, so fg = buffer/file name, if unedited
  let s:palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)                  "{{{
  let s:palette.normal_modified                   = { 'airline_c': modified_group }
  let s:palette.normal.airline_warning            = warning_group
  let s:palette.normal_modified.airline_warning   = warning_group
  let s:palette.normal.airline_error              = error_group
  let s:palette.normal_modified.airline_error     = error_group                               "}}}
  " Insert:
  let s:I1 = airline#themes#get_highlight2(['Normal',            'bg'],  ['Identifier',   'fg'])
  let s:I2 = s:N2         "git section stays the same across all
  let s:I3 = airline#themes#get_highlight2(['BruvboxBrightGray', 'fg'],  ['StatusLineNC', 'fg'])
  let s:palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)                  "{{{
  let s:palette.insert_modified                   = s:palette.normal_modified
  let s:palette.insert.airline_warning            = warning_group
  let s:palette.insert_modified.airline_warning   = warning_group
  let s:palette.insert.airline_error              = error_group
  let s:palette.insert_modified.airline_error     = error_group                               "}}}
  " Replace:
  let s:R1 = airline#themes#get_highlight2(['Normal',    'bg'],          ['Structure',    'fg'])
  let s:R2 = s:I2
  " let s:R3 = airline#themes#get_highlight2(['Normal',    'fg'],          ['BruvboxBg2_h', 'fg'])
  let s:R3 = airline#themes#get_highlight2(['BruvboxBrightGray', 'fg'],          ['BruvboxBg2_h', 'fg'])
  let s:palette.replace = airline#themes#generate_color_map(s:R1, s:R2, s:R3)                 "{{{
  let s:palette.replace_modified                  = s:palette.normal_modified
  let s:palette.replace.airline_warning           = warning_group
  let s:palette.replace_modified.airline_warning  = warning_group
  let s:palette.replace.airline_error             = error_group
  let s:palette.replace_modified.airline_error    = error_group                               "}}}
  " Visual: 
  let s:V1 = airline#themes#get_highlight2(['Normal',     'bg'],         ['BruvboxPurpleSign', 'fg'])
  let s:V2 = s:N2
  let s:V3 = s:R3
  let s:palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)                  "{{{
  let s:palette.visual_modified = { 'airline_c': [ s:V3[0], '', s:V3[2], '', '' ] }
  let s:palette.visual.airline_warning            = warning_group
  let s:palette.visual_modified.airline_warning   = warning_group
  let s:palette.visual.airline_error              = error_group
  let s:palette.visual_modified.airline_error     = error_group                               "}}}

  " Inactive:
  let s:IA1 = airline#themes#get_highlight2(['TabLine',     'fg'],       ['BruvboxBg0', 'fg'])
  let s:IA2 = airline#themes#get_highlight2(['BruvboxBg4',  'fg'],       ['TabLineFill', 'bg'])
  let s:IA3 = airline#themes#get_highlight2(['TabLine',     'fg'],       ['TabLineFill', 'bg'])
  let s:palette.inactive = airline#themes#generate_color_map(s:IA1, s:IA2, s:IA3)
  let s:palette.inactive_modified                 = { 'airline_c': modified_group }

  let s:TF = airline#themes#get_highlight2(['Normal',       'bg'],       ['TabLineFill',  'bg'])
  let s:palette.tabline = {
    \ 'airline_tab':      airline#themes#get_highlight('TabLine'),
    \ 'airline_tabsel':   s:N1,
    \ 'airline_tabtype':  s:V1,
    \ 'airline_tabfill':  s:TF,
    \ 'airline_tabhid':   s:IA1,
    \ 'airline_tabmod':   warning_reverse
    \ }

  let s:green   = airline#themes#get_highlight('BruvboxGreen')
  let s:yellow  = airline#themes#get_highlight('BruvboxYellow')
  let s:red     = airline#themes#get_highlight('BruvboxRed')
  let s:purple  = airline#themes#get_highlight('BruvboxPurple')
  let s:blue    = airline#themes#get_highlight('BruvboxBlue')
  let s:aqua    = airline#themes#get_highlight('BruvboxAqua')
  let s:orange  = airline#themes#get_highlight('BruvboxOrange')
  let s:palette.accents = { 'green': s:green, 'yellow': s:yellow, 'red': s:red, 'purple': s:purple, 'blue': s:blue, 'aqua': s:aqua, 'orange': s:orange }

endfunction

let g:airline#themes#bruvbox#palette = s:palette
call airline#themes#bruvbox#refresh()

" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
