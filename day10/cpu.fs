17 constant linelength
variable file-id
variable linebuf linelength allot

s" input.txt" r/o open-file throw Value file-id

: get-line ( -- eof )
  linebuf linelength file-id read-line throw
  swap drop
;

: get-number ( c-addr -- n )
  dup
  ( read signed decimal number from the given address, 10 chars )
  10 s>number? throw drop
  swap
  ( If the number starts with a minus sign, negate it )
  c@ 45 = if
    ( cr ." negating " dup . cr )
    negate
  then
;

: noop dup ;
: addx ( n1 n2 -- n1 n1 sum ) over dup rot + ;

: execop ( c-addr -- )
  ( cr )
  ( Read the first character to determine the operation )
  c@
  97 = if
    ( read number from input+5 )
    linebuf 5 + get-number
    addx
  else
    noop
  then
;

: flushline ( -- ) linelength chars linebuf ! ;

: inputloop ( -- )
  ( Start the first instruction with a leading 1, then remove it )
  1
  get-line drop linebuf execop
  swap drop
  flushline

  ( while there are still lines in the file, read and execute them )
  begin
    get-line
  while
    linebuf execop
    flushline
  repeat
;

