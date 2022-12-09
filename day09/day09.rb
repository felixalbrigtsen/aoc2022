class RopeKnot
  attr_accessor :pos, :tail, :positions

  def initialize(tail = {})
    @pos = { "x" => 0, "y" => 0 }
    @positions = [ [0, 0] ]
    @tail = tail
  end

  def move(direction, distance)
    for i in 1..distance
      case direction
      when "U"
        @pos["y"] += 1
      when "D"
        @pos["y"] -= 1
      when "L"
        @pos["x"] -= 1
      when "R"
        @pos["x"] += 1
      end

      if !@tail.nil?
        @tail.follow(@pos)
      end
    end
  end

  def follow(headpos)
    # If the tail is already neighboring the head, don't move (pythagorean theorem)
    if (headpos["x"] - @pos["x"])**2 + (headpos["y"] - @pos["y"])**2 <= 2
      return
    end

    if (headpos["x"] > @pos["x"]) then @pos["x"] += 1 end
    if (headpos["x"] < @pos["x"]) then @pos["x"] -= 1 end

    if (headpos["y"] > @pos["y"]) then @pos["y"] += 1 end
    if (headpos["y"] < @pos["y"]) then @pos["y"] -= 1 end

    if !@positions.include?([@pos["x"], @pos["y"]])
      @positions.push([@pos["x"], @pos["y"]])
    end

    if @tail.is_a? RopeKnot
      @tail.follow(@pos)
    end
  end

end

p1 = [RopeKnot.new]
p1.push(RopeKnot.new(p1[0]))

p2 = [RopeKnot.new]
for i in 0..8
  p2.push(RopeKnot.new(p2[i]))
end

# Read input file
if ARGV.length == 0
  puts "Usage: day09.rb <input_file>"
  exit
end

inputFile = ARGV[0]
input = File.read(inputFile)

# Parse input
input = input.split("\n")
for i in 0..input.length-1
  input[i] = input[i].split(" ")
  dir = input[i][0]
  dist = input[i][1].to_i

  p1[1].move(dir, dist)
  p2[9].move(dir, dist)
end

puts "Part 1, number of visited locations: #{p1[0].positions.length}"
puts "Part 2, number of visited locations: #{p2[0].positions.length}"
