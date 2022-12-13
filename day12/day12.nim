import std/algorithm
import os

type
  Point = object
    x: int
    y: int

var
  point_S: Point
  point_E: Point
  rows: int
  cols: int
  grid: seq[seq[int]]

proc readInput(filename: string): seq[string] =
  var lines = newSeq[string](0)
  let f = open(filename, fmRead)
  while not endOfFile(f):
    let line = readLine(f)
    lines.add(line)

  return lines

proc heuristic(a: Point, finish: Point): int =
  return abs(a.x-finish.x) + abs(a.y-finish.y)

proc reconstructPath(cameFrom: seq[Point], current: Point): seq[Point] =
  var path = newSeq[Point](0)
  path.add(current)

  while (path[path.len-1] != cameFrom[path[path.len-1].y*cols+path[path.len-1].x]):
    let prev = path[path.len-1]
    let next = cameFrom[prev.y*cols+prev.x]

    if path.contains(next):
      echo "DEBUG: error in astar, path contains a loop"
      break

    path.add(next)

  return path.reversed


proc astar(mountain: seq[seq[int]], start: Point, finish: Point): seq[Point] =
  # Pretty much just https://en.wikipedia.org/wiki/A*_search_algorithm
  var 
    openSet = newSeq[Point](0)
    cameFrom = newSeq[Point](rows*cols)
    gScore = newSeq[int](rows*cols)
    fScore = newSeq[int](rows*cols)

  openSet.add(start)
  gscore[start.y*cols+start.x] = 0

  for i in 0 ..< rows*cols:
    cameFrom[i] = Point(x: -1, y: -1)
    gScore[i] = high(int)
    fScore[i] = high(int)

  gScore[start.y*cols+start.x] = 0
  cameFrom[start.y*cols+start.x] = start

  fscore[start.y*cols+start.x] = heuristic(start, finish)

  while openSet.len > 0:
    # Find the node with the lowest fScore
    var
      current = openSet[0]
      currentIndex = 0
    for i in 0 ..< openSet.len:
      if fScore[openSet[i].y*cols+openSet[i].x] < fScore[current.y*cols+current.x]:
        current = openSet[i]
        currentIndex = i

    # If we found the finish, we're done
    if current.x == finish.x and current.y == finish.y:
      return reconstructPath(cameFrom, current)

    openSet.delete(currentIndex)

    var neighbors = newSeq[Point](0)

    # If there is a neighbor to the left
    if current.x > 0 and (grid[current.y][current.x-1] - grid[current.y][current.x]) <= 1:
      neighbors.add(Point(x: current.x-1, y: current.y))

    # If there is a neighbor to the right
    if current.x < cols-1 and (grid[current.y][current.x+1] - grid[current.y][current.x]) <= 1:
      neighbors.add(Point(x: current.x+1, y: current.y))

    # If there is a neighbor above
    if current.y > 0 and (grid[current.y-1][current.x] - grid[current.y][current.x]) <= 1:
      neighbors.add(Point(x: current.x, y: current.y-1))
    
    # If there is a neighbor below
    if current.y < rows-1 and (grid[current.y+1][current.x] - grid[current.y][current.x]) <= 1:
      neighbors.add(Point(x: current.x, y: current.y+1))

    for i in 0 ..< neighbors.len:
      let neighbor = neighbors[i]
      let neighborIndex = neighbor.y*cols+neighbor.x
      let tentativeGScore = gScore[current.y*cols+current.x] + 1

      if tentativeGScore < gScore[neighborIndex]: 
        #If the new gscore for the neighbor is better than the old one
        cameFrom[neighborIndex] = current
        gScore[neighborIndex] = tentativeGScore
        fScore[neighborIndex] = tentativeGScore + heuristic(neighbor, finish)

        if not openSet.contains(neighbor):
          openSet.add(neighbor)

  # No path was found, return an empty sequence
  return newSeq[Point](0)


# Main; read the input and build the grid

if paramCount() == 0:
  echo "Usage: ", paramStr(0), " <input file>"
  quit(1)

let lines = readInput(paramStr(1))
rows = lines.len
cols = lines[0].len

# Parse step: Read the lines and build the grid of numbers
for y in 0 ..< rows:
  grid.add(newSeq[int](cols))
  for x in 0 ..< cols:
    var c = lines[y][x]
    if c == 'S':
      point_S = Point(x: x, y: y)
      c = 'a'
    elif c == 'E':
      point_E = Point(x: x, y: y)
      c = 'z'

    grid[y][x] = ord(c)-ord('a')

echo "Start: ", point_S
echo "Finish: ", point_E

let shortestPath = astar(grid, point_S, point_E)
echo "Part 1: ", shortestPath.len-1

var part2Shortest = shortestPath.len-1
for y in 0 ..< rows:
  for x in 0 ..< cols:
    if grid[y][x] == 0: # If the starting point is "a"
      let newPath = astar(grid, Point(x: x, y: y), point_E)
      if newPath.len > 0:
        part2Shortest = min(part2Shortest, newPath.len-1)

echo "Part 2: ", part2Shortest