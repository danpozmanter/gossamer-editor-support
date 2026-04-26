if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal cindent
setlocal cinoptions=L0,(0,Ws,JN,j1,m1
setlocal cinkeys=0{,0},0),0],!^F,o,O,e
setlocal indentexpr=
