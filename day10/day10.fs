include cpu.fs

: part1 ( -- score )
  1 ( x register )
  inputloop ( read input and process )

  cr ." Part 1 steps: "

  begin depth 220 > while drop repeat ( Anything after 220 cycles are discarded )

  0
  begin
    swap dup depth 2 - * dup . rot + ( top score -- top newscore ) ( addedpoints=depth*top )
    depth 40 >=
  while
    40 0 do swap drop loop
  repeat

  20 0 do swap drop loop
;


variable outbuf 42 allot

: part2row ( n1 n2 n3 ... n40 -- ) ( reads 40 numbers, processes them and prints the result )
    ( for each pixel in this row, set # if the pixel is in the sprite )
    40 0 do
      39 I - swap - ( remember: stacks require some reversing )
      dup -1 >= swap 1 <= and if
        35 outbuf I + c!
      then
    loop

    ( print and clear outbuf, in reverse )
    40 0 do
      39 I - dup
      outbuf swap + c@ emit
      outbuf + 46 swap c!
    loop
    cr
;

: part2 ( -- )
  ( this method expects the stack to start empty, because relies hevily on "depth" )
  cr

  40 0 do 46 outbuf I + c! loop ( clear output buffer with periods )
  1 ( x register )
  inputloop ( read input and process )

  begin depth 240 > while drop repeat ( Anything after 240 cycles are discarded )

  begin
    depth 0>
  while
    part2row
  repeat
;
