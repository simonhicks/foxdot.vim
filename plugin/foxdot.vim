if exists("g:foxdot_vim_loaded")
  finish
endif
let g:foxdot_vim_loaded = 1

command! FoxDotStart call foxdot#start()
