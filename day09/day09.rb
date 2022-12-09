class RopeMover
  attr_reader :head, :tail, :tailPositions

  def initialize
    @head = { "x" => 0, "y" => 0 }
    @tail = { "x" => 0, "y" => 0 }
    @tailPositions = [[0, 0]]
  end

  def move(direction, distance)
    for i in 1..distance
      case direction
      when "U"
        @head["y"] += 1
      when "D"
        @head["y"] -= 1
      when "L"
        @head["x"] -= 1
      when "R"
        @head["x"] += 1
      end
      self.updateTail
    end
  end

  def updateTail

    # If the tail is already neighboring the head, don't move (pythagorean theorem)
    if (@head["x"] - @tail["x"])**2 + (@head["y"] - @tail["y"])**2 <= 2
      return
    end
    # puts "Updating tail towards #{@head["x"]}, #{@head["y"]}\n"

    if (@head["x"] > @tail["x"]) then @tail["x"] += 1 end
    if (@head["x"] < @tail["x"]) then @tail["x"] -= 1 end

    if (@head["y"] > @tail["y"]) then @tail["y"] += 1 end
    if (@head["y"] < @tail["y"]) then @tail["y"] -= 1 end


    if !@tailPositions.include?([@tail["x"], @tail["y"]])
      @tailPositions.push([@tail["x"], @tail["y"]])
    end

  end

end


rope = RopeMover.new

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
  rope.move(input[i][0], input[i][1].to_i)
end

puts "Part 1, number of visited locations: #{rope.tailPositions.length}"
