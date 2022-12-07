#! /bin/bash

ELFSUM=0
ELVES=()

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <input file>"
    exit 1
fi

if [[ ! -f $1 ]]; then
    echo "File $1 does not exist"
    exit 1
fi

while IFS= read -r LINE; do
  if [[ $LINE = "" ]]; then
    ELVES+=( "$ELFSUM" )
    ELFSUM=0
    echo "New group"
  else
    ELFSUM=$((ELFSUM + LINE))
    echo "Added $LINE to sum, now $ELFSUM"
  fi
done < "$1"
ELVES+=( "$ELFSUM" )

echo ""

echo "Part 1:"
echo "${ELVES[*]}" | tr ' ' '\n' | sort -r -n | head -n 1

echo "Part 2:"
echo "${ELVES[*]}" | tr ' ' '\n' | sort -n | tail -n 3 | awk '{s+=$1} END {print s}' -

