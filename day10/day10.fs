include cpu.fs

: part1 ( -- )
  1 ( x register )
  inputloop ( read input and process )

  cr ." Part 1 steps: "

  begin
    depth 220 >
  while
    drop
  repeat

  0
  begin
    swap dup depth 2 - * dup . rot +
    depth 40 >=
  while
    40 0 do swap drop loop
  repeat

  20 0 do swap drop loop

  cr ." Part 1: " . cr cr
;

part1
