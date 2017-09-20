scriptencoding utf-8
" -----------------------------------------------------------------------------
" File: colors/bruvbox.vim
" Description: Faded groove color schenable mobilebackupseme for Vim. Shamelessly forked from Gruvbox. 
" Author: Bruvbox by @tolgraven.    Gruvbox by morhetz <morhetz@gmail.com>
" Source: https://github.com/tolgraven/bruvbox
" Last Modified: Apr 2017
" -----------------------------------------------------------------------------
" Supporting code -------------------------------------------------------------
"{{{1         Initialisation: 
hi clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name='bruvbox'
if !has('gui_running') && &t_Co != 256  | finish   | endif

"{{{1         Global Settings: 
let g:bruvbox_bold      = get(g:, 'bruvbox_bold',      1)
let g:bruvbox_undercurl = get(g:, 'bruvbox_undercurl', 1)
let g:bruvbox_underline = get(g:, 'bruvbox_underline', 1)
let g:bruvbox_inverse   = get(g:, 'bruvbox_inverse  ', 1)
if !exists('g:bruvbox_italic')
  if has('gui_running') || $TERM_ITALICS ==? 'true'
    let      g:bruvbox_italic   = 1    "also check for like tmux way of enabling, tho...
  else | let g:bruvbox_italic   = 0     | endif
endif
if !exists('g:bruvbox_guisp_fallback') || index(['fg', 'bg'], g:bruvbox_guisp_fallback) == -1
  let g:bruvbox_guisp_fallback='NONE'
endif

let g:bruvbox_termcolors           = get(g:, 'bruvbox_termcolors', 256)
let g:bruvbox_invert_indent_guides = get(g:, 'bruvbox_invert_indent_guides', 0)
let g:bruvbox_contrast_dark        = get(g:, 'bruvbox_contrast_dark', 'medium')
let g:bruvbox_contrast_light       = get(g:, 'bruvbox_contrast_light', 'medium')
let s:is_dark=(&background ==# 'dark')  " works, but leads to first initing light if bg not set before colorscheme in vimrc
" let s:is_dark = 1

"{{{1         Palette: 
let s:bb = {}  " setup palette dictionary
"{{{        NOTES
"IDEA: instead of bg/base gray, turn it (so bg, also comments, etc) ever so faintly bluish hue!! could be shit but suspect might be very pretty?
"PER "start with purely faded gruvbox, before tweaking further":
"BRUVBOX:	bg				  red 			green 		yellow 		blue 			purple 		aqua 			gray 		
"normal 	#393939 	#a4ad49 	#939233 	#c6943a 	#4d8487 	#a56784 	#6b976e 					
"bright 						    #cb5d4e 	#aaae4a 	#d8ac67 	#829d93 	#c38495 	#8bb47d 					
"    				bg0_h			  bg0 			bg1 			bg2 			bg3 			bg4 			gray 			orange
"bg 	  		#1d2821  	#282828 	#3c3836 	#505945 	#665c54 	#7c6f64 	#928374 	#c5632c
"fg 					#32302f 	 #a89984 	#bdae93 	#d5c4a1 	#ebdbb2 	#fbf1c7 	#d68035
 
"GRUVBOX: bg				red 			green 		yellow 		blue 			purple 		aqua 			gray 		
"normal 	#282828 	#cc241d 	#b8bb26
"bright 		
" 				bg0_h			bg0 			bg1 			bg2 			bg3 			bg4 			gray 			orange
"bg 			#1d2821  	#282828 	#3c3836 	#505945 	#665c54 	#7c6f64 	#928374 	#d68035d0e
"fg 								#32302f 	#a89984 	#bdae93 	#d5c4a1 	#ebdbb2 	#fbf1c7 	#fe8019
"}}}
" {{{2         DARK / LIGHT
let s:bb.black       = ['#181919', 233]     "the darkest we dare go... 233 is about ot on

let s:bb.dark0_hard  = ['#212223', 234]     " 
let s:bb.dark0_hard2 = ['#232526', 234]     " 
let s:bb.dark0       = ['#272828', 235]     " 282828 is orig gb dark0
let s:bb.dark0_medium= ['#2b2c2e', 236]     " 
let s:bb.dark0_soft  = ['#303133', 236]     " 

let s:bb.dark1_hard  = ['#37373a', 237]     " 
let s:bb.dark1       = ['#3c393c', 237]     " 
let s:bb.dark1_soft  = ['#3f4040', 238]     " 

let s:bb.dark2_hard  = ['#4c4643', 239]     " 
let s:bb.dark2       = ['#504945', 239]     " 80-73-69
let s:bb.dark2_soft  = ['#575452', 240]     " 

let s:bb.dark3       = ['#665c54', 241]     " 102-92-84
let s:bb.dark4       = ['#7c6f64', 243]     " 124-111-100
let s:bb.dark4_256   = ['#7c6f64', 243]     " 124-111-100

let s:bb.gray_244    = ['#928374', 244]     " 146-131-116
let s:bb.gray_245    = ['#90868a', 245]     " 146-131-116
let s:bb.gray_248    = ['#8a8e8f', 248]     " 146-131-116


let s:bb.white       = ['#fdfbe8', 255]     

let s:bb.light0_hard2= ['#faf8e0', 255]     " 
let s:bb.light0_hard = ['#f9f5d7', 255]     " 249-245-215
let s:bb.light0      = ['#fbf1c7', 254]     " 253-244-193
let s:bb.light0_medium=['#f8e8bf', 253]     " 242-229-188
let s:bb.light0_soft = ['#f0e3ba', 253]     " 242-229-188

let s:bb.light1_hard = ['#efddb5', 252]     " 235-219-178
let s:bb.light1      = ['#ebdbb2', 252]     " 235-219-178
let s:bb.light1_soft = ['#e4d5a9', 252]     " 235-219-178
let s:bb.light2_hard = ['#dccca9', 250]     " 213-196-161
let s:bb.light2      = ['#d5c4a1', 250]     " 213-196-161
let s:bb.light2_soft = ['#c5c09a', 250]     " 213-196-161
let s:bb.light3      = ['#bdae93', 248]     " 189-174-147
let s:bb.light4      = ['#a89984', 246]     " 168-153-132
let s:bb.light4_256  = ['#a89984', 246]     " 168-153-132
let s:bb.bright_gray = ['#af9f91', 244]     " 
"}}}
" XXX instead of contrast hi/mid/low have 1-50-100 scale for saturation and contrast! calc bounds and math around
let s:bb.bright_red       = ['#c55d4e', 167]     " #a4ad49 aint rea lol... errorrr.  #d33a27 or so is gruv orig
let s:bb.bright_green     = ['#a0a172', 142]     " tweaking off special=#8b8c63... old #919535
let s:bb.bright_yellow    = ['#d0af60', 214]     "  #c2923a
let s:bb.bright_blue      = ['#528895', 109]     " 109 = #7c9a9a. srbb says #83a598 for regular ble sign
let s:bb.bright_blue_alt  = ['#6995b6', 109]     " 
let s:bb.bright_purple    = ['#a58a99', 175]     " #b2a5ce in iterm palette  #B78AA2 fish
" let s:bb.bright_aqua      = ['#6f9e85', 108]     " off #6f9879 . 108 = 7c9a7b. too similar. #749783 what I get for orig.
let s:bb.bright_aqua      = ['#6e916e', 108]     " off #6f9879 . 108 = 7c9a7b. too similar. #749783 what I get for orig.
let s:bb.bright_orange    = ['#ca782b', 208]     " getting close to perfect after further fade

let s:bb.neutral_red      = ['#c7271f', 124]     " 204-36-29
let s:bb.neutral_green    = ['#919535', 106]     " #98971a 152-151-26
let s:bb.neutral_yellow   = ['#d79921', 172]     " 215-153-33
let s:bb.neutral_blue     = ['#458588', 66]      " but old one 4d8487 might actually look nicer as bg statusline... hmm
let s:bb.neutral_blue_alt = ['#4d8487', 66]      " test
let s:bb.neutral_purple   = ['#a06782', 132]     " 177-98-134
let s:bb.neutral_aqua     = ['#60906a', 72]      " 104-157-106
let s:bb.neutral_orange   = ['#c15d1e', 166]     " 214-93-14
" used for light mode, repurpose:
let s:bb.faded_red        = ['#990607', 88]      " 157-0-6
let s:bb.faded_green      = ['#79740e', 100]     " 121-116-14
let s:bb.faded_yellow     = ['#b57614', 136]     " 181-118-20
let s:bb.faded_blue       = ['#1b6678', 24]      " 7-102-120
let s:bb.faded_purple     = ['#8a4e7f', 96]      " 143-63-113
let s:bb.faded_aqua       = ['#407955', 66]      " 66-123-88
let s:bb.faded_orange     = ['#af4f11', 130]     " 175-58-3
" bright, desat
let s:bb.special_red      = ['#af6360', 124]
let s:bb.special_green    = ['#8b8c63', 10]
let s:bb.special_yellow   = ['#dabd7a', 11]
let s:bb.special_blue     = ['#80a0b3', 111] "close enough but doesnt quite match up fully... for folds. #84a8j 
let s:bb.special_purple   = ['#af8589', 172]
let s:bb.special_aqua     = ['#9ab499', 172]
let s:bb.special_orange   = ['#d2845d', 172]
" very dark colors, only for use as background and with light text (no matter what mode)
let s:bb.bg_dark_red      = ['#430605', 88]      " 
let s:bb.bg_dark_green    = ['#233509', 100]     " 
let s:bb.bg_dark_yellow   = ['#604009', 136]     " 
let s:bb.bg_dark_blue     = ['#314061', 24]      " 
let s:bb.bg_dark_purple   = ['#734663', 96]      " 
let s:bb.bg_dark_aqua     = ['#306346', 66]      " 
let s:bb.bg_dark_orange   = ['#703009', 130]     " 
" super faint tingle of a hue...
let s:bb.bg_light_red     = ['#e3a19f', 124]
let s:bb.bg_light_green   = ['#d3d4a8', 10]
let s:bb.bg_light_yellow  = ['#e9d8b4', 11]
let s:bb.bg_light_blue    = ['#a6c0cd', 111] "close enough. for folds. #84a8j -s | grep .config/fisherman/ | while read line; cd (string split ':' $line)[2]; and j -d 100; endcd working from
let s:bb.bg_light_purple  = ['#d9b7b7', 172]
let s:bb.bg_light_aqua    = ['#B6D1B4', 172]
let s:bb.bg_light_orange  = ['#ddbdaf', 172]
" more color talk  #86AB89 gre #AEC0A1 vlight gr / turqu   {{{
" so the eerily spot on accidental colors were:
" #84825A light(?) gree   nice desat... maybe fade a tiny bit more and will be nice for strings
" #D7875F really good creamy orangey
" #AF8786 faded purp - tho think that one's defined like that? - nope gruvbox is #a76783
" #D7AF60 Seems almost perfect. faded yello - or is it the same as gruvbox? - 
" so bright is for dark bg, faded for light But we should use all groups, whatever mode, for inverted text etc....
"
" gruvbox 256 ble vs aqu bug: super close colors. Ble already has lots of gree in it but theyre not remotely this close...
" #7e9bd0    my color #4 shows > #80a0b3  110 might be alright actually. 109 is too gree and 111 maybe bit too ble/bright, but eh
" #799ca1 my tmux statusline

" #7b9ec3 bubblegum airline insert
" #536E97 dark blu.fish #2C3B8A other values depending on where in antialiasing looking... 
" #5579E3
" #314061 nice deep dark blu #49838D nice medium ble  #ACCFBD turquois / lightlight ble: 
" #5f8787 gruvboxes basic I guess...
" #6D7833 #7f9d4a   green candidates
" Green looks nice but doesnt contrast enough with comments. Maybe Need a bit more brightness in the color, but def not more saturation.
" Aqua is too strong
" Red prob tiny bit too strong
" Orange def tiiiiny bit too strong (and too similar to red)
 "}}}


"{{{1         Glyphs:
let s:bb.glyph_arrow_opened_fill    ='▾'    "for nerdtree, tagbar and similar
let s:bb.glyph_arrow_closed_fill    ='▸'
let s:bb.glyph_arrow_opened_lined   =''
let s:bb.glyph_arrow_closed_lined   =''
let s:bb.glyph_arrow_dense          ='➧'    "any point to these?
let s:bb.glyph_arrow_heavy          ='➨'
let s:bb.glyph_pipe                 ='│'
let s:bb.glyph_pinned               =''    "font awesome? for taboo, renamed tabs
let s:bb.glyph_branch               =''
let s:bb.glyph_warning              =''
let s:bb.glyph_error                =''
let s:bb.glyph_modified             ='◈'
let s:bb.glyph_linenr               =''
let s:bb.glyph_whitespace           ='☲'
let s:bb.glyph_paste                ='ρ'       "curr 'PASTE'
let s:bb.glyph_spell                ='Ꞩ'       " 'SPELL'

let s:bb.glyph_recycle              =''
let s:bb.glyph_again                ='↺'
let s:bb.glyph_back                 ='⤸'
let s:bb.glyph_arrow_circled        ='➲'

let s:bb.glyph_vim                  =''
let s:bb.glyph_file                 =''

let s:bb.glyph_separator_arrow_fill          =''
let s:bb.glyph_separator_arrow_fill_back     =''
let s:bb.glyph_separator_triangle_left_above =''
let s:bb.glyph_separator_triangle_left_below =''
let s:bb.glyph_separator_triangle_right_above=''
let s:bb.glyph_separator_triangle_right_below=''
let s:bb.glyph_separator_slash               =''
let s:bb.glyph_separator_slash_back          =''
let s:bb.glyph_separator_arrow_lined         =''
let s:bb.glyph_separator_arrow_lined_back    =''

" let g:airline_left_sep 														=''    "  vs ⮀ ''  
" let g:airline_left_alt_sep 												=' '    "'│' 	
" let g:airline_right_sep 													=''     "''  
" let g:airline_right_alt_sep 											=''     "'│'


" signs:
let s:bb.glyph_sign_added           ='✚'
let s:bb.glyph_sign_changed         ='✹'
let s:bb.glyph_sign_deleted         =''    "XXX find better
let s:bb.glyph_sign_changed_deleted =''
let s:bb.glyph_sign_warning         =s:bb.glyph_warning
let s:bb.glyph_sign_error           =s:bb.glyph_error

let s:bb.glyph_type_buffer          =''    " ℬ  b B
let s:bb.glyph_type_tab             =''    "no but srsly find something usable
" let s:bb.glyph_type_window          =''
let s:bb.glyph_type_terminal        =''

let s:bb.glyph_mode_normal          ='N'
let s:bb.glyph_mode_insert          =''
let s:bb.glyph_mode_linewise        =''
let s:bb.glyph_mode_colwise         ='▢'

let s:bb.glyph_source_buffer        =s:bb.glyph_type_buffer
let s:bb.glyph_source_around        =''    "''
let s:bb.glyph_source_web           =''
let s:bb.glyph_source_vim           =s:bb.glyph_vim
let s:bb.glyph_source_path          ='./'.s:bb.glyph_file      "''
let s:bb.glyph_source_omni          =''
let s:bb.glyph_source_jedi          =''
let s:bb.glyph_source_tern          =''
let s:bb.glyph_source_tag           =''
let s:bb.glyph_source_snippet       =''
let s:bb.glyph_source_syntax        ='♯'



"{{{1         Setup Recommended Glyphs:
" if s:bruvbox_use_recommended_glyphs
" etc etc

"{{{1         Setup Recommended Settings:
" if s:bruvbox_use_recommended_settings
" etc etc


" let g:taboo_renamed_tab_format      =' %l%m'


"{{{1         Setup Emphasis: 
let s:bold      = (g:bruvbox_bold      ? 'bold,'      : '')
let s:italic    = (g:bruvbox_italic    ? 'italic,'    : '')
let s:underline = (g:bruvbox_underline ? 'underline,' : '')
let s:undercurl = (g:bruvbox_undercurl ? 'undercurl,' : '')
let s:inverse   = (g:bruvbox_inverse   ? 'inverse,'   : '')
"{{{1         Setup Colors: 
let s:vim_bg = ['bg', 'bg']     | let s:vim_fg = ['fg', 'fg']  | let s:none = ['NONE', 'NONE']

if s:is_dark  " determine relative colors
  " if g:bruvbox_contrast_dark     ==? 'soft'  | let s:bg0 = s:bb.dark0_soft
  " elseif g:bruvbox_contrast_dark ==? 'hard'  | let s:bg0 = s:bb.dark0_hard | endif
  let s:bg_hard = s:bb.black
  let s:fg_hard = s:bb.white

  let s:bg0_h2 = s:bb.dark0_hard2
  let s:bg0  = s:bb.dark0 | let s:bg0_s = s:bb.dark0_soft    | let s:bg0_m = s:bb.dark0_medium     | let s:bg0_h  = s:bb.dark0_hard   
  let s:bg1  = s:bb.dark1 | let s:bg1_s = s:bb.dark1_soft    | let s:bg1_h = s:bb.dark1_hard   
  let s:bg2  = s:bb.dark2 | let s:bg2_s = s:bb.dark2_soft    | let s:bg2_h = s:bb.dark2_hard   
  let s:bg3  = s:bb.dark3 | let s:bg4   = s:bb.dark4
  
  let s:gray = s:bb.gray_244 | let s:gray2 = s:bb.gray_248

  let s:fg0  = s:bb.light0 | let s:fg0_s   = s:bb.light0_soft  | let s:fg0_m = s:bb.light0_medium  | let s:fg0_h = s:bb.light0_hard
  let s:fg1  = s:bb.light1 | let s:fg1_s = s:bb.light1_soft | let s:fg1_h = s:bb.light1_hard 
  let s:fg2  = s:bb.light2 | let s:fg2_s = s:bb.light2_soft | let s:fg2_h = s:bb.light2_hard 
  let s:fg3  = s:bb.light3 | let s:fg4   = s:bb.light4

  let s:fg4_256 = s:bb.light4_256

  let s:red    = s:bb.bright_red
  let s:green  = s:bb.bright_green
  let s:yellow = s:bb.special_yellow "s:bb.bright_yellow
  let s:blue   = s:bb.bright_blue
  let s:purple = s:bb.special_purple "bright_purple
  let s:aqua   = s:bb.bright_aqua
  let s:orange = s:bb.bright_orange

  let s:bg_red    = s:bb.bg_dark_red
  let s:bg_green  = s:bb.bg_dark_green
  let s:bg_yellow = s:bb.bg_dark_yellow
  let s:bg_blue   = s:bb.bg_dark_blue
  let s:bg_purple = s:bb.bg_dark_purple
  let s:bg_aqua   = s:bb.bg_dark_aqua
  let s:bg_orange = s:bb.bg_dark_orange

  let s:search_background = s:bb.faded_blue

else "{{{     LIGHT THEME
  " if     g:bruvbox_contrast_light ==? 'soft' | let s:bg0  = s:bb.light0_soft
  " elseif g:bruvbox_contrast_light ==? 'hard' | let s:bg0  = s:bb.light0_hard | endif   
  let s:bg_hard = s:bb.white
  let s:fg_hard = s:bb.black

  let s:bg0  = s:bb.light0 | let s:bg0_s = s:bb.light0_soft | let s:bg0_m = s:bb.light0_medium | let s:bg0_h = s:bb.light0_hard
  " XXX fix actual shades for these
  let s:bg0_h2 = s:bb.light0_hard
  let s:bg1  = s:bb.light1 | let s:bg1_s  = s:bb.light1 | let s:bg1_h  = s:bb.light1 | 
  let s:bg2  = s:bb.light2 | let s:bg2_s  = s:bb.light2 | let s:bg2_h  = s:bb.light2 | 
  let s:bg3  = s:bb.light3 | let s:bg4    = s:bb.light4

  let s:gray = s:bb.gray_244 | let s:gray2 = s:bb.gray_248

  let s:fg0 = s:bb.dark0 | let s:fg0_s = s:bb.dark0_soft | let s:fg0_m = s:bb.dark0_medium | let s:fg0_h = s:bb.dark0_hard
  let s:fg1 = s:bb.dark1 | let s:fg1_s = s:bb.dark1_soft | let s:fg1_h = s:bb.dark1_hard
  let s:fg2 = s:bb.dark2 | let s:fg2_s = s:bb.dark2_soft | let s:fg2_h = s:bb.dark2_hard
  let s:fg3 = s:bb.dark3 | let s:fg4 = s:bb.dark4

  let s:fg4_256 = s:bb.dark4_256

  let s:red    = s:bb.faded_red
  let s:green  = s:bb.faded_green
  let s:yellow = s:bb.faded_yellow
  let s:blue   = s:bb.faded_blue
  let s:purple = s:bb.faded_purple
  let s:aqua   = s:bb.faded_aqua
  let s:orange = s:bb.faded_orange

  let s:bg_red    = s:bb.bg_light_red    
  let s:bg_green  = s:bb.bg_light_green  
  let s:bg_yellow = s:bb.bg_light_yellow 
  let s:bg_blue   = s:bb.bg_light_blue   
  let s:bg_purple = s:bb.bg_light_purple 
  let s:bg_aqua   = s:bb.bg_light_aqua   
  let s:bg_orange = s:bb.bg_light_orange 

  let s:search_background = s:bb.special_blue

endif "}}}

let s:special_red    = s:bb.special_red
let s:special_green  = s:bb.special_green
let s:special_yellow = s:bb.special_yellow
let s:special_blue   = s:bb.special_blue
let s:special_purple = s:bb.special_purple
let s:special_aqua   = s:bb.special_aqua
let s:special_orange = s:bb.special_orange

let s:neutral_red    = s:bb.neutral_red
let s:neutral_green  = s:bb.neutral_green
let s:neutral_yellow = s:bb.neutral_yellow
let s:neutral_blue   = s:bb.neutral_blue
let s:neutral_purple = s:bb.neutral_purple
let s:neutral_aqua   = s:bb.neutral_aqua
let s:neutral_orange = s:bb.neutral_orange

" set up 16 colors terminal fallback {{{
if g:bruvbox_termcolors == 16
  let s:bg0[1]    = 0
  let s:fg4[1]    = 7
  let s:gray[1]   = 8
  let s:red[1]    = 9
  let s:green[1]  = 10
  let s:yellow[1] = 11
  let s:blue[1]   = 12
  let s:purple[1] = 13
  let s:aqua[1]   = 14
  let s:fg1[1]    = 15
endif
"}}}
" save current relative colors back to palette dictionary {{{
let s:bb.bg_hard = s:bg_hard
let s:bb.bg0 = s:bg0 | let s:bb.bg0_s = s:bg0_s | let s:bb.bg0_m = s:bg0_m | let s:bb.bg0_h = s:bg0_h
let s:bb.bg1 = s:bg1 | let s:bb.bg1_h = s:bg1_h
let s:bb.bg2 = s:bg2 | let s:bb.bg2_h = s:bg2_h
let s:bb.bg3 = s:bg3 | let s:bb.bg4   = s:bg4

let s:bb.gray = s:gray | let s:bb.gray2 = s:gray2

let s:bb.fg_hard = s:fg_hard
let s:bb.fg0 = s:fg0 | let s:bb.fg0_s = s:fg0 | let s:bb.fg0_m = s:fg0 | let s:bb.fg0_h = s:fg0
let s:bb.fg1 = s:fg1 | let s:bb.fg2   = s:fg2 | let s:bb.fg3   = s:fg3 | let s:bb.fg4   = s:fg4

let s:bb.fg4_256 = s:fg4_256

let s:bb.red    = s:red
let s:bb.green  = s:green
let s:bb.yellow = s:yellow
let s:bb.blue   = s:blue
let s:bb.purple = s:purple
let s:bb.aqua   = s:aqua
let s:bb.orange = s:orange
"}}}

"{{{1           Export palette as global var, for the enjoyment of the public
let g:bruvbox_palette = s:bb
" i guess so we can hook into our colors backwards from vimrc/other scripts instead of just going from origin, out
" cool thing actually if going all out bloat, and thinking grander...  would be sourcing our palette from a file in the first place, and if user
" modifies global var, save that to like a ~/.config/bruvbox type ting, and offer to source palette from there instead next time. Full dynamic + then easy to adapt to other envs
"}}}

"{{{1         Overload Setting: 
let s:hls_cursor           = get(s:bb, get(g:, 'bruvbox_hls_cursor',     'faded_blue'))
" let s:search_background    = get(s:bb, get(g:, 'bruvbox_search_background', 'faded_blue'))
let s:cursorline_bg        = get(s:,   get(g:, 'bruvbox_cursorline_bg',  'bg0_s'))
let s:underline_cursorline =           get(g:, 'bruvbox_underline_cursorline',  0)
" trad colors for these were: h, s, s, s
let s:number_column        = get(s:,   get(g:, 'bruvbox_number_column',  'bg0_s'))
let s:color_column         = get(s:,   get(g:, 'bruvbox_color_column',   'bg0_s'))
let s:sign_column          = get(s:,   get(g:, 'bruvbox_sign_column',    'bg0_m'))
let s:fold_column          = get(s:,   get(g:, 'bruvbox_fold_column',    'bg0_m'))
if get(g:, 'gitgutter_override_sign_column_highlight', 0) == 1
  let s:sign_column = s:number_column  | let g:gitgutter_override_sign_column_highlight = 0 | endif
let s:vert_split           = get(s:,   get(g:, 'bruvbox_vert_split',     'bg0_h'))  "bg1


let s:invert_signs         = (get(g:, 'bruvbox_invert_signs',     0) == 1 ? s:inverse  : '')
let s:invert_selection     = (get(g:, 'bruvbox_invert_selection', 1) == 1 ? s:inverse  : '')
" let s:invert_search        = (get(g:, 'bruvbox_invert_search',    1) == 1 ? s:inverse  : '')
let s:invert_tabline       = (get(g:, 'bruvbox_invert_tabline',   0) == 1 ? s:inverse  : '')
let s:invert_errors        = (get(g:, 'bruvbox_invert_errors',    0) == 1 ? s:inverse  : '')
"for motion/search/jump plugs
let s:invert_targets       =  get(g:, 'bruvbox_invert_targets_when_rest_faded',  0)
let s:italicize_comments   = (get(g:, 'bruvbox_italicize_comments', 1) == 1 ? s:italic : '')
let s:italicize_strings    = (get(g:, 'bruvbox_italicize_strings',  0) == 1 ? s:italic : '')

" not used yet
let s:color_mode_normal    = get(g:, 'bruvbox_normal_mode_color',     s:green)
let s:color_mode_insert    = get(g:, 'bruvbox_insert_mode_color',     s:red)
let s:color_mode_visual    = get(g:, 'bruvbox_visual_mode_color',     s:purple)  "purple sign actually... iz same?
let s:replace_mode_color   = get(g:, 'bruvbox_replace_mode_color',    s:yellow)  "yellow sign, dito

" }}}
"{{{1         Highlighting Function: 

function! s:HL(group, fg, ...)  " Arguments: group, guifg, guibg, gui, guisp
  let fg = a:fg
  if a:0 >= 1  | let bg = a:1   | else   | let bg = s:none          | endif
  if a:0 >= 2 && strlen(a:2)    | let mod = a:2
  else                          | let mod = 'NONE,'                 | endif

  if a:0 >= 3
    if g:bruvbox_guisp_fallback !=? 'NONE'  | let fg = a:3          | endif
    " bg fallback mode should invert higlighting
    if g:bruvbox_guisp_fallback ==? 'bg'    | let mod .= 'inverse,' | endif
    let l:special = 'guisp=' . a:3[0]
  endif

  let hi = ['hi', a:group, 'guifg='.fg[0],   'guibg='.bg[0],   'gui='.mod[:-2],
                      \  'ctermfg='.fg[1], 'ctermbg='.bg[1], 'cterm='.mod[:-2],
                      \   get(l:, 'special', '')]
  execute join(hi, ' ')
endfunction

" }}}
"{{{1         Bruvbox Hi Groups: 
"{{{          FG / BG 
call s:HL('BruvboxFg0',  s:fg0)  | call s:HL('BruvboxFg0_h', s:fg0_h) | call s:HL('BruvboxFg0_m', s:fg0_m) | call s:HL('BruvboxFg0_s', s:fg0_s)
call s:HL('BruvboxFg1',  s:fg1)  | call s:HL('BruvboxFg1_h', s:fg1_h)
call s:HL('BruvboxFg2',  s:fg2)  | call s:HL('BruvboxFg2_h', s:fg2_h)
call s:HL('BruvboxFg3',  s:fg3)  | call s:HL('BruvboxFg4',   s:fg4)
call s:HL('BruvboxGray', s:gray) | call s:HL('BruvboxGray2', s:gray2)
call s:HL('BruvboxBrightGray',     s:bb.bright_gray)
call s:HL('BruvboxBgHard',         s:none,        s:bg_hard)
call s:HL('BruvboxFgHard',         s:fg_hard,     s:none,           s:bold)
call s:HL('BruvboxHardOnHard',     s:fg_hard,     s:bg_hard)

call s:HL('BruvboxBg0', s:bg0)  | call s:HL('BruvboxBg0_h', s:bg0_h) | call s:HL('BruvboxBg0_m', s:bg0_m) | call s:HL('BruvboxBg0_s', s:bg0_s)
call s:HL('BruvboxBg1', s:bg1)  | call s:HL('BruvboxBg1_h', s:bg1_h) | call s:HL('BruvboxBg1_s', s:bg1_s)
call s:HL('BruvboxBg2', s:bg2)  | call s:HL('BruvboxBg2_h', s:bg2_h) | call s:HL('BruvboxBg2_s', s:bg2_s)
call s:HL('BruvboxBg3', s:bg3)  | call s:HL('BruvboxBg4',   s:bg4)
"}}}
" standard colors: for regular dark, based on 'bright' palette.
call s:HL('BruvboxRed',            s:red)
call s:HL('BruvboxGreen',          s:green)
call s:HL('BruvboxYellow',         s:yellow)
call s:HL('BruvboxBlue',           s:blue)
call s:HL('BruvboxPurple',         s:purple)
call s:HL('BruvboxAqua',           s:aqua)
call s:HL('BruvboxOrange',         s:orange)
call s:HL('BruvboxRedBold',        s:red,            s:none,             s:bold)
call s:HL('BruvboxGreenBold',      s:green,          s:none,             s:bold)
call s:HL('BruvboxYellowBold',     s:yellow,         s:none,             s:bold)
call s:HL('BruvboxBlueBold',       s:blue,           s:none,             s:bold)
call s:HL('BruvboxPurpleBold',     s:purple,         s:none,             s:bold)
call s:HL('BruvboxAquaBold',       s:aqua,           s:none,             s:bold)
call s:HL('BruvboxOrangeBold',     s:orange,         s:none,             s:bold)

call s:HL('BruvboxRedNeutral',     s:neutral_red)
call s:HL('BruvboxGreenNeutral',   s:neutral_green)
call s:HL('BruvboxYellowNeutral',  s:neutral_yellow)
call s:HL('BruvboxBlueNeutral',    s:neutral_blue)
call s:HL('BruvboxPurpleNeutral',  s:neutral_purple)
call s:HL('BruvboxAquaNeutral',    s:neutral_aqua)
call s:HL('BruvboxOrangeNeutral',  s:neutral_orange)

" will have to experiment with light or dark fg...
call s:HL('BruvboxRedFadedBg',       s:bb.light0,      s:bb.faded_red,     s:bold)
call s:HL('BruvboxGreenFadedBg',     s:bb.light0,      s:bb.faded_green,   s:bold)
call s:HL('BruvboxYellowFadedBg',    s:bb.dark0,       s:bb.faded_yellow,  s:bold)
call s:HL('BruvboxBlueFadedBg',      s:bb.light0,      s:bb.faded_blue,    s:bold)
call s:HL('BruvboxPurpleFadedBg',    s:bb.light0,      s:bb.faded_purple,  s:bold)
call s:HL('BruvboxAquaFadedBg',      s:bb.light0,      s:bb.faded_aqua,    s:bold)
call s:HL('BruvboxOrangeFadedBg',    s:bb.dark0,       s:bb.faded_orange,  s:bold)

" for sign column, also other minor standout highlights since sign column (by default anyways) has light bg than Normal
call s:HL('BruvboxRedSign',        s:red,            s:sign_column,      s:invert_signs)
call s:HL('BruvboxGreenSign',      s:green,          s:sign_column,      s:invert_signs)
call s:HL('BruvboxYellowSign',     s:yellow,         s:sign_column,      s:invert_signs)
call s:HL('BruvboxBlueSign',       s:blue,           s:sign_column,      s:invert_signs)
call s:HL('BruvboxPurpleSign',     s:purple,         s:sign_column,      s:invert_signs)
call s:HL('BruvboxAquaSign',       s:aqua,           s:sign_column,      s:invert_signs)
call s:HL('BruvboxOrangeSign',     s:orange,         s:sign_column,      s:invert_signs)
call s:HL('BruvboxFgSign',         s:fg_hard,        s:sign_column,      s:invert_signs)

" light-ish background, text regular. prob should make sure it's not fully the
" same as any other bg color, so it will always stand out at least a bit...
call s:HL('BruvboxRedInfo',        s:red,            s:bg1_h,            s:italic)
call s:HL('BruvboxGreenInfo',      s:green,          s:bg1_h,            s:italic)
call s:HL('BruvboxYellowInfo',     s:yellow,         s:bg1_h,            s:italic)
call s:HL('BruvboxBlueInfo',       s:blue,           s:bg1_h,            s:italic)
call s:HL('BruvboxPurpleInfo',     s:purple,         s:bg1_h,            s:italic)
call s:HL('BruvboxAquaInfo',       s:aqua,           s:bg1_h,            s:italic)
call s:HL('BruvboxOrangeInfo',     s:orange,         s:bg1_h,            s:italic)
call s:HL('BruvboxFgInfo',         s:fg_hard,        s:bg1,              s:italic)

" faint as fuck, bg only, text must be proper white/black
" call s:HL('BruvboxRedBg',          s:bb.fg0,      s:bg_red      )
" call s:HL('BruvboxGreenBg',        s:bb.fg0,      s:bg_green    )
" call s:HL('BruvboxYellowBg',       s:bb.fg0,      s:bg_yellow,  )
" call s:HL('BruvboxBlueBg',         s:bb.fg0,      s:bg_blue     )
" call s:HL('BruvboxPurpleBg',       s:bb.fg0,      s:bg_purple,  )
" call s:HL('BruvboxAquaBg',         s:bb.fg0,      s:bg_aqua     )
" call s:HL('BruvboxOrangeBg',       s:bb.fg0,      s:bg_orange,  )
call s:HL('BruvboxRedBg',          s:none,      s:bg_red      )
call s:HL('BruvboxGreenBg',        s:none,      s:bg_green    )
call s:HL('BruvboxYellowBg',       s:none,      s:bg_yellow,  )
call s:HL('BruvboxBlueBg',         s:none,      s:bg_blue     )
call s:HL('BruvboxPurpleBg',       s:none,      s:bg_purple,  )
call s:HL('BruvboxAquaBg',         s:none,      s:bg_aqua     )
call s:HL('BruvboxOrangeBg',       s:none,      s:bg_orange,  )

" same color but fg 
call s:HL('BruvboxRedHue',         s:bg_red)
call s:HL('BruvboxGreenHue',       s:bg_green)
call s:HL('BruvboxYellowHue',      s:bg_yellow)
call s:HL('BruvboxBlueHue',        s:bg_blue)
call s:HL('BruvboxPurpleHue',      s:bg_purple)
call s:HL('BruvboxAquaHue',        s:bg_aqua)
call s:HL('BruvboxOrangeHue',      s:bg_orange)

call s:HL('BruvboxRedSpecial',     s:bb.special_red,       s:none)
call s:HL('BruvboxGreenSpecial',   s:bb.special_green,     s:none)
call s:HL('BruvboxYellowSpecial',  s:bb.special_yellow,    s:none)
call s:HL('BruvboxBlueSpecial',    s:bb.special_blue,      s:none)
call s:HL('BruvboxPurpleSpecial',  s:bb.special_purple,    s:none)
call s:HL('BruvboxAquaSpecial',    s:bb.special_aqua,      s:none)
call s:HL('BruvboxOrangeSpecial',  s:bb.special_orange,    s:none)

" mode color groups
call s:HL('BruvboxNormalModeColor', s:color_mode_normal,   s:none)
call s:HL('BruvboxInsertModeColor', s:color_mode_insert,   s:none)
call s:HL('BruvboxVisualModeColor', s:color_mode_visual,   s:none)
call s:HL('BruvboxCursorLineNr',    s:color_mode_normal,   s:color_column)

" }}}


" Vanilla colorscheme ---------------------------------------------------------
"{{{1         General UI: 
call s:HL('Normal',         s:fg1_h,            s:bg0)  " got errors when not defining both fg and bg for normal. Undef bg seems better for neovim though, from reading through issues. Check that gruvbox PR allowing this.
if s:is_dark | set background=dark   | else | set background=light    | endif   "workaround for vim being a shithead

call s:HL('CursorLine',     s:none,           s:cursorline_bg)
hi!  link  CursorColumn     CursorLine
" below aint working, dunno why... so augroup still in vimrc for now.
" if s:underline_cursorline == 1      | augroup CursorLine | autocmd!
"     autocmd InsertEnter * 	highlight CursorLine gui=underline,bold cterm=underline,bold
"     autocmd InsertLeave * 	highlight CursorLine gui=none           cterm=none
"   augroup END                       | endif

call s:HL('TabLineFill',    s:fg4,            s:bg0_h,          s:invert_tabline)
call s:HL('TabLineSel',     s:vim_bg,         s:bg4,            s:bold . s:invert_tabline)
call s:HL('TabLine',        s:fg4,            s:bg0_m)

hi! link   MatchParen       Visual

call s:HL('QuickFixLine',   s:vim_fg,         s:vim_bg,         s:underline)

call s:HL('ColorColumn',    s:none,           s:color_column)
call s:HL('Conceal',        s:bb.faded_blue,  s:none)          " Concealed element: \lambda → λ

hi! link   SpecialKey       BruvboxBg3              "'unprintable characters' whatever that means. ^c sorta ting?
" call s:HL('NonText',        s:bg0_h2,          s:none)  "eol, TODO: support for if want colorcolumn/nontext bg to fade darker instead of lighter, fg needs to follow along
call s:HL('NonText',        s:bg0_s,          s:none)  "eol, TODO: support for if want colorcolumn/nontext bg to fade darker instead of lighter, fg needs to follow along
call s:HL('Whitespace',     s:bg0_s,          s:none)  "tab chars and stuff. links to NonText by default
call s:HL('EndOfBuffer',    s:color_column,   s:color_column)  "fg completely invisible, so dont have to see the stupid ~s after EOF
call s:HL('Visual',         s:none,           s:bg0_s,          s:invert_selection)
hi! link   VisualNOS        Visual                             "removed from neovim but meh, no harm

" call s:HL('Search',         s:bb.light0,          s:hls_cursor,)  "     s:invert_search)
call s:HL('Search',         s:fg0,          s:search_background,)  "     s:invert_search)
" call s:HL('Search',         s:fg0,          s:bg_blue,)  "     s:invert_search)
" call s:HL('IncSearch',      s:hls_cursor,            s:fg1,       s:underline) ". s:invert_search)  " current match: flipped from Search. Blue on white instead of white on blue...
hi! link  IncSearch         Visual
" call s:HL('IncSearchCursor', s:fg0_s,         s:bb.faded_blue,    s:bold . s:invert_search)       
call s:HL('IncSearchCursor', s:hls_cursor,           s:fg0_s,       s:bold) " . s:invert_search)       

call s:HL('Underlined',     s:none,           s:none,             s:underline)

call s:HL('StatusLine',     s:bg0_h,          s:fg4,              s:inverse)      " try blending LineNr-VertSplit-TabLine-StatusLine... as bg0_h
call s:HL('StatusLineNC',   s:bg0_h,          s:color_mode_normal, s:inverse)
call s:HL('VertSplit',      s:bg0_s,          s:bg0_h) "shifts focus from fg to fg turning it into more like a double pipe, looks fucking great!


hi! link   Directory        BruvboxBlueSign  "BruvboxBlueSpecial    " Directory names, special names in listing
hi! link   Title            BruvboxPurpleSign     " Titles for output from :set all, :autocmd, etc.
hi! link   ErrorMsg         BruvboxRedSign
hi! link   WarningMsg       BruvboxYellowSign    "BruvboxYellowNeutral
hi! link   Question         BruvboxYellowInfo     " 'Press enter' prompt and yes/no questions
hi! link   MoreMsg          BruvboxFg4            " More prompt: -- More --
hi! link   ModeMsg          BruvboxFg2            " Current mode message: -- INSERT --

"{{{1         Gutter: 
call s:HL('LineNr',         s:bg2_s,          s:number_column)
" call s:HL('LineNr',         s:bg3,          s:number_column)
hi!  link  CursorLineNr     BruvboxCursorLineNr   " Linked his way because we need the original stored somewhere when switching fg color dynamically for insert mode, via autocmds.
call s:HL('SignColumn',     s:none,           s:sign_column)

call s:HL('Folded',         s:bb.special_blue, s:fold_column,  s:italic) "Line used for closed folds
call s:HL('FoldColumn',     s:bg0,             s:fold_column)            "Best compromise between legibility and not looking like shit I've come up with thus far
"{{{1         Cursor: 
call s:HL('Cursor',         s:none,           s:none,    s:inverse) " Character under cursor
call s:HL('vCursor',        s:none,           s:none,    s:inverse . s:underline . s:bold)  " Visual mode cursor, selection
hi! link  iCursor           Cursor                              " Input mode cursor
hi! link  lCursor           Cursor                              " Language mapping cursor
hi! link  TermCursor        Cursor
" call s:HL('TermCursorNC')  "cleared

" {{{1       Syntax Highlighting: 

hi! link   Special          BruvboxOrange

hi! link   Todo             BruvboxPurpleSign
hi! link   Error            BruvboxRedSign

" FLOW
hi! link   Statement        BruvboxBlue             " Generic statement. def, return
hi! link   Conditional      BruvboxBlueBold         " if, then, else, endif, switch, etc
hi! link   Repeat           BruvboxBlueSign         " for, do, while, etc.
hi! link   Label            BruvboxBlueNeutral      " case, default, etc.
hi! link   Exception        BruvboxBlueInfo         " try, catch, throw, except, etc.
hi! link   Keyword          BruvboxBlueSpecial      " any other keyword

hi! link   Operator         BruvboxFgHard            " sizeof, "+", "*", etc.
" hi! link   Delimiter        ?                     " links to Special default

hi! link   Identifier       BruvboxRed              " Variable name
" hi! link   Function         BruvboxOrangeSpecial
call s:HL('Function',       s:bb.special_orange,  s:none,  s:bold)

" IMPORT / INCLUDE / PREPROCESSOR / MACROS
hi! link   PreProc          BruvboxAqua             " Generic   preprocessor
hi! link   Include          BruvboxAqua
hi! link   Define           BruvboxAquaSign
hi! link   Macro            BruvboxAquaSign         " Same as Define
hi! link   PreCondit        BruvboxAquaBold

" NUMBERS N SHIT
hi! link   Constant         BruvboxPurpleSign       " Generic   constant
hi! link   Character        BruvboxPurple           " Character constant: 'c', '/n'
hi! link   Number           BruvboxPurple
hi! link   Float            BruvboxPurple
hi! link   Boolean          BruvboxRedSign

hi! link   Type             BruvboxYellow           " Generic type
hi! link   StorageClass     BruvboxYellowNeutral       " static, register, volatile, etc
hi! link   Structure        BruvboxYellowSign        " struct, union, enum, etc.
hi! link   Typedef          BruvboxYellowBold
call s:HL('String',         s:green,         s:none,               s:italicize_strings)
call s:HL('Comment',        s:gray,          s:none,               s:italicize_comments)

" {{{1        Completion: 
call s:HL('Pmenu',          s:fg1,           s:cursorline_bg)     " Popup menu: normal item, makes sense to link bg to whatever used for CursorLine, so drops down smoothly :)
call s:HL('PmenuSel',       s:fg0,           s:neutral_blue,       s:bold)  " selected item     s:bg0_s, s:blue
call s:HL('PmenuSbar',      s:none,          s:bg0_h)             " scrollbar
call s:HL('PmenuThumb',     s:none,          s:bb.bg_light_blue)   " scrollbar thumb       s:none, s:bg2

call s:HL('WildMenu',       s:fg0,           s:bb.faded_blue,      s:bold)  " Current match in wildmenu completion     s:blue,  s:bg1,
"{{{1         Diffs: 
" call s:HL('DiffAdd',        s:none,          s:bb.bg_dark_green)
hi! link   DiffAdd          BruvboxGreenBg
" call s:HL('DiffDelete',     s:none,          s:bb.bg_dark_red)  
hi! link   DiffDelete       BruvboxRedBg
" call s:HL('DiffChange',     s:none,          s:bb.bg_dark_yellow)
hi! link   DiffChange       BruvboxYellowBg
call s:HL('DiffText',       s:none,          s:bb.faded_green,     s:inverse)  " The actual changed text in changed line...

"{{{1         Spelling: 
if has('spell')
  call s:HL('SpellCap',     s:green,         s:none,               s:bold . s:italic)   " Not capitalised word, or compile warnings
  call s:HL('SpellBad',     s:none,          s:none,               s:undercurl,   s:blue)
  call s:HL('SpellLocal',   s:none,          s:none,               s:undercurl,   s:aqua)
  call s:HL('SpellRare',    s:none,          s:none,               s:undercurl,   s:purple)
endif
" }}}

"{{{1         Neovim Terminal Colors:
if has('nvim')
  " couple of these are repeating now since yellow is already defined as special_yellow etc, fix
  " wasnt working prev bc all defs are rgb+256-index, so must grab the first one and not entire thing

  " base 8 colors:
  let g:terminal_color_0  = s:bg0_h[0]
  let g:terminal_color_1  = s:red[0]
  let g:terminal_color_2  = s:green[0]
  let g:terminal_color_3  = s:yellow[0]
  let g:terminal_color_4  = s:blue[0]
  let g:terminal_color_5  = s:purple[0]
  let g:terminal_color_6  = s:aqua[0]
  let g:terminal_color_7  = s:fg0_s[0]
  " bright/bold dittos:
  let g:terminal_color_8  = s:bg2[0]
  let g:terminal_color_9  = s:orange[0]
  let g:terminal_color_10 = s:special_yellow[0]
  let g:terminal_color_11 = s:special_green[0]
  let g:terminal_color_12 = s:special_blue[0]
  let g:terminal_color_13 = s:special_purple[0]
  let g:terminal_color_14 = s:special_aqua[0]
  let g:terminal_color_15 = s:fg0_s[0]
endif

"}}}



"{{{1 Plugin specific -------------------------------------------------------------


"{{{2          ColDevIcons test

let g:coldevicons_colormap = {
        \'Brown'        : '#905532',
        \'Aqua'         : s:aqua[0],
        \'Blue'         : s:blue[0],
        \'Darkblue'     : s:bb.faded_blue[0],
        \'Purple'       : s:purple[0],
        \'Red'          : s:red[0],
        \'Beige'        : s:special_orange[0],
        \'Yellow'       : s:special_yellow[0],
        \'Orange'       : s:orange[0],
        \'Darkorange'   : s:bb.bg_dark_orange[0],
        \'Pink'         : s:special_purple[0],
        \'Salmon'       : '#EE6E73',
        \'Green'        : s:bb.bright_green[0],
        \'Lightgreen'   : s:green[0],
        \'White'        : s:fg0_h[0]
    \}
"}}}

" FIX:    FZF,    Denite

" jump plugin group def
" XXX doesnt work with light bg
if s:invert_targets == 0 | call s:HL('JumpTarget',  s:bb.special_blue,  s:bg_hard,    s:bold)
else                     | call s:HL('JumpTarget',  s:fg0_h,            s:bb.faded_blue)    | endif

"{{{2         ChooseWin:
hi! link  ChooseWinLabel          BruvboxBlueSign
hi! link  ChooseWinLabelCurrent   BruvboxOrangeSign
hi! link  ChooseWinLand           BruvboxAqua
hi! link  ChooseWinOther          BruvboxOrangeSign
hi! link  ChooseWinOverlay        BruvboxBlueSign
hi! link  ChooseWinOverlayCurrent BruvboxOrangeSign
hi! link  ChooseWinShade          BruvboxBg3

"{{{2         EasyMotion: 
"for motion/search/jump plugs
hi! link  EasyMotionTarget   JumpTarget
hi! link  EasyMotionShade    Comment

"{{{2         Sneak: 
hi! link  Sneak              JumpTarget
hi! link  SneakScope         BruvboxBgHard
" hi! link SneakLabel         Search        "defaults to mirroring Sneak
hi! link  SneakLabelMask     Comment

"{{{2         Lista: 
hi! link  ListaSearchHitBuffer   JumpTarget
" hi! link  ListaSearchHitFuzzy   "make something like, HL each char properly, then somewhere between faded and hit for the span between.
" hi! link  ListaSearchShade       Comment

"{{{2         Indent Guides: 
if !exists('g:indent_guides_auto_colors') | let g:indent_guides_auto_colors = 0 | endif
if g:indent_guides_auto_colors == 0
  if g:bruvbox_invert_indent_guides == 0
    call s:HL('IndentGuidesEven', s:vim_bg, s:bg0)
    call s:HL('IndentGuidesOdd',  s:vim_bg, s:bg0_h2)
  else
    call s:HL('IndentGuidesOdd',  s:vim_bg, s:bg2, s:inverse)
    call s:HL('IndentGuidesEven', s:vim_bg, s:bg3, s:inverse)
  endif
endif
" IndentLine: {{{2
if !exists('g:indentLine_color_term') | let g:indentLine_color_term = s:bg2[1] | endif
if !exists('g:indentLine_color_gui')  | let g:indentLine_color_gui  = s:bg2[0] | endif

"{{{2         Rainbow Parentheses: 
if !exists('g:rbpt_colorpairs')
  let g:rbpt_colorpairs = [
      \ ['blue', '#458588'],  ['magenta', '#b16286'],
      \ ['red',  '#cc241d'],  ['166',     '#d65d0e']  ]
endif

let g:rainbow_guifgs    = [ '#d65d0e', '#cc241d', '#b16286', '#458588' ]
let g:rainbow_ctermfgs  = [ '166', 'red', 'magenta', 'blue' ]

if !exists('g:rainbow_conf')              | let g:rainbow_conf = {}     | endif
if !has_key(g:rainbow_conf, 'guifgs')     | let g:rainbow_conf['guifgs']    = g:rainbow_guifgs    | endif
if !has_key(g:rainbow_conf, 'ctermfgs')   | let g:rainbow_conf['ctermfgs']  = g:rainbow_ctermfgs  | endif

let g:niji_dark_colours   = g:rbpt_colorpairs
let g:niji_light_colours  = g:rbpt_colorpairs

"{{{2         GitGutter: 
hi! link GitGutterAdd           BruvboxGreenSign
hi! link GitGutterChange        BruvboxAquaSign
hi! link GitGutterDelete        BruvboxRedSign
hi! link GitGutterChangeDelete  BruvboxYellowSign
""{{{2        GitCommit: 
hi! link gitcommitSelectedFile  BruvboxGreen
hi! link gitcommitDiscardedFile BruvboxRed
"{{{2         Signify: 
hi! link SignifySignAdd         BruvboxGreenSign
hi! link SignifySignChange      BruvboxAquaSign
hi! link SignifySignDelete      BruvboxRedSign
"{{{2         ALE:
call s:HL('ALEError',   s:none, s:bb.bg_dark_red,    s:undercurl, s:red)
call s:HL('ALEWarning', s:none, s:bb.bg_dark_yellow, s:undercurl, s:yellow)
hi! link ALEErrorSign     BruvboxRedSign
hi! link ALEWarningSign   BruvboxFgSign "BruvboxYellowSign
" if blabla like 'use line HL instead of file' <- que?
"   hi! ALEWarningLine
"   hi! ALEErrorLine
" endif
"{{{2         Syntastic: 
hi! link SyntasticError       ALEError
hi! link SyntasticWarning     ALEWarning
hi! link SyntasticErrorSign   ALEErrorSign
hi! link SyntasticWarningSign ALEWarningSign
"{{{2         Signature: 
hi! link SignatureMarkText   BruvboxBlueSign
hi! link SignatureMarkerText BruvboxPurpleSign
"{{{2         ShowMarks: 
hi! link ShowMarksHLl     BruvboxBlueSign
hi! link ShowMarksHLu     BruvboxBlueSign
hi! link ShowMarksHLo     BruvboxBlueSign
hi! link ShowMarksHLm     BruvboxBlueSign
"{{{2         CtrlP: 
hi! link CtrlPMatch       BruvboxBlue
hi! link CtrlPNoEntries   BruvboxRedInfo
hi! link CtrlPPrtBase     BruvboxBg1
hi! link CtrlPPrtCursor   BruvboxOrange
hi! link CtrlPLinePre     BruvboxBg2
call s:HL('CtrlPMode1',   s:blue, s:bg2,  s:bold)
call s:HL('CtrlPMode2',   s:bg0,  s:blue, s:bold)
call s:HL('CtrlPStats',   s:fg4,  s:bg2,  s:bold)
"{{{2         Startify: 
hi! link StartifyBracket  BruvboxBg4
hi! link StartifyFile     BruvboxBlueSign
hi! link StartifyNumber   BruvboxOrange
hi! link StartifyPath     BruvboxFg4
hi! link StartifySlash    BruvboxFg2
hi! link StartifySection  BruvboxYellow
hi! link StartifySpecial  BruvboxBg2
hi! link StartifyHeader   BruvboxOrange
hi! link StartifyFooter   BruvboxBg2
"{{{2         NERDTree: 
hi! link	 NERDTreeOpenable        BruvboxBlueSign		 
hi! link  NERDTreeClosable        BruvboxOrangeSign	 
hi! link  NERDTreeDir             Directory
hi! link  NERDTreeLinkDir         BruvboxAquaSign	 
hi! link  NERDTreeLinkFile        BruvboxFg3
hi! link  NERDTreeLinkTarget      Comment		
hi! link  NERDTreeDirSlash        Function
hi! link  NERDTreeCWD             BruvboxOrangeSign
hi! link  NERDTreeBookmarkName    BruvboxBlueSpecial
hi! link  NERDTreeBookmarksLeader BruvboxOrangeHue
hi! link  NERDTreeBookmark        BruvboxFg3
hi! link  NERDTreeHelpTitle       BruvboxBlue
hi! link  NERDTreeHelp            Comment

"{{{2          Undotree: 
hi! link UndotreeAdd      DiffAdd
hi! link UndotreeChange   DiffChange

"{{{2          Tagbar: 

hi! link  TagbarKind             BruvboxRedInfo     "header of generic 'kinds', functions/variables.
hi! link  TagbarNestedKind       BruvboxRedSpecial  "kind headers, within scopes.
hi! link  TagbarScope            BruvboxOrangeSpecial  "scope, like class, struct.   OrangeSpecial matches code, for py anyways
hi! link  TagbarType             Statement          "type of a tag or scope.    Default Title / purpz
hi! link  TagbarSignature        BruvboxFg4         "Function signatures.     Links to SpecialKey = dark
hi! link  TagbarPseudoID         BruvboxFg3         "asterisk* that signifies a pseudo-tag.  Links to NonText = no go
hi! link  TagbarFoldIcon         BruvboxBlueInfo    "Folded  "fold icon left of foldable tags.   Default Statement / blue
hi! link  TagbarHighlight        BruvboxBlueSpecial "Colour for auto-hl current tag.   Default Search = nah
call s:HL('TagbarAccessPublic',     s:aqua,   s:none,  s:bold)
call s:HL('TagbarAccessProtected',  s:yellow, s:none,  s:bold)
call s:HL('TagbarAccessPrivate',    s:red,    s:none,  s:bold)
" hi! link  TagbarAccessPublic     BruvboxGreenBg    "public access symbol.   Default hard green. TagbarVisibilityPublic links
" hi! link  TagbarAccessProtected  BruvboxYellowSign   "protected access symbol.  Default?. TagbarVisibilityProtected links
" hi! link  TagbarAccessPrivate    BruvboxRedBg      "private access symbol.  Default hard red. TagbarVisibilityPrivate links

hi! link  TagbarHelpTitle        BruvboxBlue        "prettier/matches nerdtree
" hi! link  TagbarComment        Comment " The help at the top of the buffer.


"{{{2          Matchmaker: 
hi       Matchmaker       cterm=underline   gui=underline
" HighlightedyankRegion: {{{2
hi! link  HighlightedyankRegion   Visual
" Vimshell: {{{2
let g:vimshell_escape_colors = [
  \ s:bg4[0],  s:red[0],    s:green[0], s:yellow[0],
  \ s:blue[0], s:purple[0], s:aqua[0],  s:fg4[0],
  \ s:bg0[0],  s:red[0],    s:green[0], s:orange[0],
  \ s:blue[0], s:purple[0], s:aqua[0],  s:fg0[0]
  \ ]
" BufTabLine: {{{2
call s:HL('BufTabLineCurrent', s:bg0, s:fg4)
call s:HL('BufTabLineActive',  s:fg4, s:bg2)
call s:HL('BufTabLineHidden',  s:bg4, s:bg1)
call s:HL('BufTabLineFill',    s:bg0, s:bg0)
"}}}1
"{{{1         Filetype specific -----------------------------------------------------------
" PLAN: generally more blue more often, relegate aqua to imports and shit.
" Green can stay as string color but should be more suble. Less yellow...
" so yellow and red for like vars and stuff?
" Diff: {{{2
hi! link diffAdded        DiffAdd         "
hi! link diffRemoved      DiffDelete      "
hi! link diffChanged      DiffChange      "

hi! link diffFile         BruvboxGreen    "BruvboxOrangeBg
hi! link diffNewFile      BruvboxRed

hi! link diffLine         BruvboxBlueSpecial     "BruvboxBlue
hi! link diffSubname      BruvboxPurpleSign       "BruvboxBlue

" Html: {{{2

hi! link htmlTag            BruvboxBlue
hi! link htmlEndTag         BruvboxBlue

hi! link htmlTagName        BruvboxAquaBold
hi! link htmlArg            BruvboxAqua

hi! link htmlScriptTag      BruvboxPurple
hi! link htmlTagN           BruvboxFg1
hi! link htmlSpecialTagName BruvboxAquaBold

call s:HL('htmlLink', s:fg4, s:none, s:underline)

hi! link htmlSpecialChar BruvboxOrange

call s:HL('htmlBold',                s:vim_fg, s:vim_bg, s:bold)
call s:HL('htmlBoldUnderline',       s:vim_fg, s:vim_bg, s:bold . s:underline)
call s:HL('htmlBoldItalic',          s:vim_fg, s:vim_bg, s:bold . s:italic)
call s:HL('htmlBoldUnderlineItalic', s:vim_fg, s:vim_bg, s:bold . s:underline . s:italic)

call s:HL('htmlUnderline',       s:vim_fg, s:vim_bg, s:underline)
call s:HL('htmlUnderlineItalic', s:vim_fg, s:vim_bg, s:underline . s:italic)
call s:HL('htmlItalic',          s:vim_fg, s:vim_bg, s:italic)

" Xml: {{{2

hi! link xmlTag               BruvboxBlue
hi! link xmlEndTag            BruvboxBlue
hi! link xmlTagName           BruvboxBlue
hi! link xmlEqual             BruvboxBlue
hi! link docbkKeyword         BruvboxAquaBold

hi! link xmlDocTypeDecl       BruvboxGray
hi! link xmlDocTypeKeyword    BruvboxPurple
hi! link xmlCdataStart        BruvboxGray
hi! link xmlCdataCdata        BruvboxPurple
hi! link dtdFunction          BruvboxGray
hi! link dtdTagName           BruvboxPurple

hi! link xmlAttrib            BruvboxAqua
hi! link xmlProcessingDelim   BruvboxGray
hi! link dtdParamEntityPunct  BruvboxGray
hi! link dtdParamEntityDPunct BruvboxGray
hi! link xmlAttribPunct       BruvboxGray

hi! link xmlEntity            BruvboxOrange
hi! link xmlEntityPunct       BruvboxOrange
" Vim: {{{2

call s:HL('vimCommentTitle', s:fg4_256, s:none, s:bold . s:italicize_comments)

hi! link vimNotation  BruvboxOrange
hi! link vimBracket   BruvboxOrange
hi! link vimMapModKey BruvboxOrange
hi! link vimFuncSID   BruvboxFg3
hi! link vimSetSep    BruvboxFg3
hi! link vimSep       BruvboxFg3
hi! link vimContinue  BruvboxFg3

" Clojure: {{{2

hi! link clojureKeyword      BruvboxBlue
hi! link clojureCond         BruvboxOrange
hi! link clojureSpecial      BruvboxOrange
hi! link clojureDefine       BruvboxOrange

hi! link clojureFunc         BruvboxYellow
hi! link clojureRepeat       BruvboxYellow
hi! link clojureCharacter    BruvboxAqua
hi! link clojureStringEscape BruvboxAqua
hi! link clojureException    BruvboxRed

hi! link clojureRegexp       BruvboxAqua
hi! link clojureRegexpEscape BruvboxAqua
call s:HL('clojureRegexpCharClass', s:fg3, s:none, s:bold)
hi! link clojureRegexpMod        clojureRegexpCharClass
hi! link clojureRegexpQuantifier clojureRegexpCharClass

hi! link clojureParen        BruvboxFg3
hi! link clojureAnonArg      BruvboxYellow
hi! link clojureVariable     BruvboxBlue
hi! link clojureMacro        BruvboxOrange

hi! link clojureMeta         BruvboxYellow
hi! link clojureDeref        BruvboxYellow
hi! link clojureQuote        BruvboxYellow
hi! link clojureUnquote      BruvboxYellow

" C: {{{2
hi! link cOperator BruvboxPurple
hi! link cStructure BruvboxOrange

" Python: {{{2
hi! link pythonBuiltin     BruvboxOrangeBold      "Sign
hi! link pythonBuiltinObj  BruvboxOrangeNeutral
hi! link pythonBuiltinFunc BruvboxOrangeSign
hi! link pythonFunction    Function       "BruvboxBlue
hi! link pythonDecorator   BruvboxRed
hi! link pythonInclude     Include      "BruvboxAqua
hi! link pythonImport      Include      "BruvboxAqua
" hi! link pythonRun         BruvboxBlue
" hi! link pythonCoding      BruvboxBlue
" hi! link pythonOperator    BruvboxRedSpecial   "Identifier     "BruvboxRed
call s:HL('pythonOperator',       s:fg2,      s:sign_column,    s:underline . s:bold)
hi! link pythonExtraOperator    Operator  "BruvboxRed
hi! link pythonExceptions  Exception               "BruvboxPurple
hi! link pythonBoolean     Boolean        "BruvboxPurple
hi! link pythonDot         BruvboxFg3
hi! link pythonComma       BruvboxFg3

hi! link pythonBrackets    Special
hi! link pythonBraces      Special   
" hi! link pythonBraces         

highlight! link pythonSelf BruvboxFg3   "not default

" CSS: {{{2
hi! link cssBraces               BruvboxBlue
hi! link cssFunctionName         BruvboxYellow
hi! link cssIdentifier           BruvboxOrange
hi! link cssClassName            BruvboxGreen
hi! link cssColor                BruvboxBlue
hi! link cssSelectorOp           BruvboxBlue
hi! link cssSelectorOp2          BruvboxBlue
hi! link cssImportant            BruvboxGreen
hi! link cssVendor               BruvboxFg1

hi! link cssTextProp             BruvboxAqua
hi! link cssAnimationProp        BruvboxAqua
hi! link cssUIProp               BruvboxYellow
hi! link cssTransformProp        BruvboxAqua
hi! link cssTransitionProp       BruvboxAqua
hi! link cssPrintProp            BruvboxAqua
hi! link cssPositioningProp      BruvboxYellow
hi! link cssBoxProp              BruvboxAqua
hi! link cssFontDescriptorProp   BruvboxAqua
hi! link cssFlexibleBoxProp      BruvboxAqua
hi! link cssBorderOutlineProp    BruvboxAqua
hi! link cssBackgroundProp       BruvboxAqua
hi! link cssMarginProp           BruvboxAqua
hi! link cssListProp             BruvboxAqua
hi! link cssTableProp            BruvboxAqua
hi! link cssFontProp             BruvboxAqua
hi! link cssPaddingProp          BruvboxAqua
hi! link cssDimensionProp        BruvboxAqua
hi! link cssRenderProp           BruvboxAqua
hi! link cssColorProp            BruvboxAqua
hi! link cssGeneratedContentProp BruvboxAqua

" JavaScript: {{{2

hi! link javaScriptBraces     BruvboxFg1
hi! link javaScriptFunction   BruvboxBlue
hi! link javaScriptIdentifier BruvboxRed
hi! link javaScriptMember     BruvboxAqua
hi! link javaScriptNumber     BruvboxPurple
hi! link javaScriptNull       BruvboxRedInfo
hi! link javaScriptParens     BruvboxFg3

" YAJS: {{{2

hi! link javascriptImport               BruvboxAqua
hi! link javascriptExport               BruvboxAqua
hi! link javascriptClassKeyword         BruvboxAqua
hi! link javascriptClassExtends         BruvboxAqua
hi! link javascriptDefault              BruvboxAqua

hi! link javascriptClassName            BruvboxYellow
hi! link javascriptClassSuperName       BruvboxYellow
hi! link javascriptGlobal               BruvboxYellow

hi! link javascriptEndColons            BruvboxFg1
hi! link javascriptFuncArg              BruvboxFg1
hi! link javascriptGlobalMethod         BruvboxFg1
hi! link javascriptNodeGlobal           BruvboxFg1

" hi! link javascriptVariable BruvboxOrange
hi! link javascriptVariable             BruvboxRed
" hi! link javascriptIdentifier BruvboxOrange
" hi! link javascriptClassSuper BruvboxOrange
hi! link javascriptIdentifier           BruvboxOrange
hi! link javascriptClassSuper           BruvboxOrange

" hi! link javascriptFuncKeyword BruvboxOrange
" hi! link javascriptAsyncFunc BruvboxOrange
hi! link javascriptFuncKeyword          BruvboxAqua
hi! link javascriptAsyncFunc            BruvboxAqua
hi! link javascriptClassStatic          BruvboxOrange

hi! link javascriptOperator             BruvboxRed
hi! link javascriptForOperator          BruvboxRed
hi! link javascriptYield                BruvboxRed
hi! link javascriptExceptions           BruvboxRed
hi! link javascriptMessage              BruvboxRed

hi! link javascriptTemplateSB           BruvboxAqua
hi! link javascriptTemplateSubstitution BruvboxFg1

" hi! link javascriptLabel BruvboxBlue
" hi! link javascriptObjectLabel BruvboxBlue
" hi! link javascriptPropertyName BruvboxBlue
hi! link javascriptLabel                BruvboxFg1
hi! link javascriptObjectLabel          BruvboxFg1
hi! link javascriptPropertyName         BruvboxFg1

hi! link javascriptLogicSymbols         BruvboxFg1
hi! link javascriptArrowFunc            BruvboxFg1

hi! link javascriptDocParamName         BruvboxFg4
hi! link javascriptDocTags              BruvboxFg4
hi! link javascriptDocNotation          BruvboxFg4
hi! link javascriptDocParamType         BruvboxFg4
hi! link javascriptDocNamedParamType    BruvboxFg4

" TypeScript: {{{2

hi! link typeScriptReserved     BruvboxAqua
hi! link typeScriptLabel        BruvboxAqua
hi! link typeScriptIdentifier   BruvboxOrange
hi! link typeScriptBraces       BruvboxFg1
hi! link typeScriptEndColons    BruvboxFg1
hi! link typeScriptDOMObjects   BruvboxFg1
hi! link typeScriptAjaxMethods  BruvboxFg1
hi! link typeScriptLogicSymbols BruvboxFg1
hi! link typeScriptDocSeeTag    Comment
hi! link typeScriptDocParam     Comment
hi! link typeScriptDocTags      vimCommentTitle

" CoffeeScript: {{{2

hi! link coffeeExtendedOp BruvboxFg3
hi! link coffeeSpecialOp BruvboxFg3
hi! link coffeeCurly BruvboxOrange
hi! link coffeeParen BruvboxFg3
hi! link coffeeBracket BruvboxOrange

" Ruby: {{{2
hi! link rubyStringDelimiter BruvboxGreen
hi! link rubyInterpolationDelimiter BruvboxAqua

" ObjectiveC: {{{2
hi! link objcTypeModifier BruvboxRed
hi! link objcDirective BruvboxBlue

" Go: {{{2
hi! link goDirective BruvboxAqua
hi! link goConstants BruvboxPurple
hi! link goDeclaration BruvboxRed
hi! link goDeclType BruvboxBlue
hi! link goBuiltins BruvboxOrange

" Lua: {{{2
hi! link luaIn BruvboxRed
hi! link luaFunction BruvboxBlue
hi! link luaTable BruvboxOrange

" MoonScript: {{{2
hi! link moonSpecialOp BruvboxFg3
hi! link moonExtendedOp BruvboxFg3
hi! link moonFunction BruvboxFg3
hi! link moonObject BruvboxYellow

" Java: {{{2
hi! link javaAnnotation BruvboxBlue
hi! link javaDocTags BruvboxAquaSign
hi! link javaCommentTitle vimCommentTitle
hi! link javaParen BruvboxFg3
hi! link javaParen1 BruvboxFg3
hi! link javaParen2 BruvboxFg3
hi! link javaParen3 BruvboxFg3
hi! link javaParen4 BruvboxFg3
hi! link javaParen5 BruvboxFg3
hi! link javaOperator BruvboxOrange

hi! link javaVarArg BruvboxYellow

" Elixir: {{{2
hi! link elixirDocString Comment

hi! link elixirStringDelimiter BruvboxGreen
hi! link elixirInterpolationDelimiter BruvboxAqua

hi! link elixirModuleDeclaration BruvboxYellow

" Scala: {{{2
" NB: scala vim syntax file is kinda horrible
hi! link scalaNameDefinition BruvboxFg1
hi! link scalaCaseFollowing BruvboxFg1
hi! link scalaCapitalWord BruvboxFg1
hi! link scalaTypeExtension BruvboxFg1

hi! link scalaKeyword BruvboxRed
hi! link scalaKeywordModifier BruvboxRed

hi! link scalaSpecial BruvboxAqua
hi! link scalaOperator BruvboxFg1

hi! link scalaTypeDeclaration BruvboxYellow
hi! link scalaTypeTypePostDeclaration BruvboxYellow

hi! link scalaInstanceDeclaration BruvboxFg1
hi! link scalaInterpolation BruvboxAqua

" Markdown: {{{2
call s:HL('markdownItalic', s:fg3, s:none, s:italic)

hi! link markdownH1 BruvboxGreenBold
hi! link markdownH2 BruvboxGreenBold
hi! link markdownH3 BruvboxYellowBold
hi! link markdownH4 BruvboxYellowBold
hi! link markdownH5 BruvboxYellow
hi! link markdownH6 BruvboxYellow

hi! link markdownCode BruvboxAqua
hi! link markdownCodeBlock BruvboxAqua
hi! link markdownCodeDelimiter BruvboxAqua

hi! link markdownBlockquote BruvboxGray
hi! link markdownListMarker BruvboxGray
hi! link markdownOrderedListMarker BruvboxGray
hi! link markdownRule BruvboxGray
hi! link markdownHeadingRule BruvboxGray

hi! link markdownUrlDelimiter BruvboxFg3
hi! link markdownLinkDelimiter BruvboxFg3
hi! link markdownLinkTextDelimiter BruvboxFg3

hi! link markdownHeadingDelimiter BruvboxOrange
hi! link markdownUrl BruvboxPurple
hi! link markdownUrlTitleDelimiter BruvboxGreen

call s:HL('markdownLinkText', s:gray, s:none, s:underline)
hi! link markdownIdDeclaration markdownLinkText

" Haskell: {{{2
" hi! link haskellType BruvboxYellow
" hi! link haskellOperators BruvboxOrange
" hi! link haskellConditional BruvboxAqua
" hi! link haskellLet BruvboxOrange
"
hi! link haskellType BruvboxFg1
hi! link haskellIdentifier BruvboxFg1
hi! link haskellSeparator BruvboxFg1
hi! link haskellDelimiter BruvboxFg4
hi! link haskellOperators BruvboxBlue
"
hi! link haskellBacktick BruvboxOrange
hi! link haskellStatement BruvboxOrange
hi! link haskellConditional BruvboxOrange

hi! link haskellLet BruvboxAqua
hi! link haskellDefault BruvboxAqua
hi! link haskellWhere BruvboxAqua
hi! link haskellBottom BruvboxAqua
hi! link haskellBlockKeywords BruvboxAqua
hi! link haskellImportKeywords BruvboxAqua
hi! link haskellDeclKeyword BruvboxAqua
hi! link haskellDeriving BruvboxAqua
hi! link haskellAssocType BruvboxAqua

hi! link haskellNumber BruvboxPurple
hi! link haskellPragma BruvboxPurple

hi! link haskellString BruvboxGreen
hi! link haskellChar BruvboxGreen

" Json: {{{2
hi! link jsonKeyword BruvboxGreen
hi! link jsonQuote BruvboxGreen
hi! link jsonBraces BruvboxFg3
hi! link jsonString BruvboxFg1


"}}}
"{{{1         Functions -------------------------------------------------------------------

" what's the point of this and why the fuck is it down here and and huh. from gruvbox. nuke?
"{{{2          Search Highlighting Cursor 
function! BruvboxHlsShowCursor()
  call s:HL('Cursor', s:bg0, s:hls_cursor)
endfunction
function! BruvboxHlsHideCursor()
  call s:HL('Cursor', s:none, s:none, s:inverse)
endfunction
" }}}1
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker:
