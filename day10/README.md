# Running the code

Much like lisp, code written in forth is more like a living image, than a script that does one thing and exits.

Both parts **can** be run by loading the file in gforth and entering "part1" or "part2".

`part1 ( -- n )` puts the target value on the stack. Display it with a simple `.` afterwards.

```
$ gforth day10.fs

redefined file-id  redefined get-line  redefined noop  Gforth 0.7.3, Copyright (C) 1995-2008 Free Software Foundation, Inc.
Gforth comes with ABSOLUTELY NO WARRANTY; for details type `license'
Type `bye' to exit

part1
Part 1 steps: 4620 3780 2940 2100 1260 320  ok
. 15020  ok
```

`part2 ( -- )` does not modify the existing stack

# Running the code (for normal people)

#### Part 1
`$ gforth day10.fs -e "part1 cr . bye " `

#### Part 2

The same can be done for part2. However, the nature of the stack makes it difficult to start working at the bottom. Forth is strictly stack based, and hence, the lines are printed in reverse order.

```
$ gforth day10.fs -e "part2 bye" > output

$ tac output
```
If you rather would like a one-liner, you can just flip the lines with sed. All the work is being done in forth, but we just have to hide the warning and flip the lines.


`$ gforth day10.fs -e "part2 bye" 2>/dev/null | sed '1!G;h;$!d' `



