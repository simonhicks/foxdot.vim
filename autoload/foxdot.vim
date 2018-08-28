if exists("g:did_autoload_foxdot")
  finish
endif
let g:did_autoload_foxdot = 1

if !exists("g:python_executable_path")
  throw "Please set g:python_executable_path"
endif
if !exists("g:sclang_executable_path")
  throw "Please set g:sclang_executable_path"
endif

let s:foxdot_base_path = fnamemodify(expand('<sfile>:h') . '/..', ':p')
let s:foxdot_server_path = fnamemodify(s:foxdot_base_path . '/bin/foxdot.scd', ':p')
let s:foxdot_cli_path = fnamemodify(s:foxdot_base_path . '/bin/foxdot_cli.py', ':p')

function! s:startSuperCollider()
  echon "Starting SuperCollider..."
  let l:sclang_dir = fnamemodify(g:sclang_executable_path, ':h')
  let l:exe = fnamemodify(g:sclang_executable_path, ':t')
  let l:cwd = getcwd()
  silent execute 'lcd '.l:sclang_dir
  let l:opts = {'err_cb': "foxdot#errHandler"}
  let s:sclang_job = job_start('"'.l:exe.'" -D "'.s:foxdot_server_path.'"', l:opts)
  silent execute 'lcd '.l:cwd
  sleep 3
  echon "done!\n"
endfunction

function! foxdot#outHandler(ch, msg)
  echo a:msg
endfunction

function! foxdot#errHandler(ch, msg)
  echoerr a:msg
endfunction

function! s:startFoxDot()
  echon "Starting FoxDot..."
  let l:opts = {}
  let l:opts.out_cb = "foxdot#outHandler"
  let l:opts.err_cb = "foxdot#errHandler"
  let s:foxdot_job = job_start('"'.g:python_executable_path.'" "'.s:foxdot_cli_path.'"', l:opts)
  let s:foxdot = job_getchannel(s:foxdot_job)
  echon "done!\n"
endfunction

function! s:setupCommands()
  command! FoxDotReboot call foxdot#reboot()
  command! -range FoxDotEval call foxdot#run(<line1>, <line2>)
  vnoremap cp :FoxDotEval<CR>
  nmap <C-CR> vipcp
endfunction

function! foxdot#run(line1, line2)
  let l:str = ''
  for l:lnum in range(a:line1, a:line2)
    let l:line = substitute(getline(l:lnum), '^[[:space:]]*', '', '')
    if match(l:line, '^\.') != -1
      let l:str = l:str . l:line
    else
      let l:str = l:str . " " . l:line
    endif
  endfor
  call ch_sendraw(s:foxdot, l:str . "\n")
endfunction

function! foxdot#start()
  call s:startSuperCollider()
  call s:startFoxDot()
  call s:setupCommands()
endfunction

function! foxdot#stop()
  call job_stop(s:foxdot_job)
  call job_stop(s:sclang_job)
endfunction

function! foxdot#reboot()
  call foxdot#stop()
  call foxdot#start()
endfunction
