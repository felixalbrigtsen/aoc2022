Stack = {}

function Stack:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function Stack:push(value)
    table.insert(self, value)
end

function Stack:pop()
    return table.remove(self)
end

function Stack:top()
    return self[#self]
end

function Stack:reverse()
    local newStack = Stack:new()
    while #self > 0 do
        newStack:push(self:pop())
    end
    return newStack
end

function Split(s, delimiter)
    result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function deepcopy(orig, copies)
    copies = copies or {}
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        if copies[orig] then
            copy = copies[orig]
        else
            copy = {}
            copies[orig] = copy
            for orig_key, orig_value in next, orig, nil do
                copy[deepcopy(orig_key, copies)] = deepcopy(orig_value, copies)
            end
            setmetatable(copy, deepcopy(getmetatable(orig), copies))
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

-- Read input data

if arg[1] == nil then
    print("Usage: "..arg[0].." <filename>")
    os.exit(1)
end
file = io.open(arg[1], "r")
if file == nil then
    print("File not found: "..arg[1])
    os.exit(1)
end

-- Parse input data

inputLines = file:read("all")
file:close()

parts = Split(inputLines, "\n\n")
initialState = Split(parts[1], "\n")
moves = Split(parts[2], "\n")

-- Initialize stacks
stackCount = (#initialState[1] + 1) // 4
stacks = {}
for i = 1, stackCount do
    stacks[i] = Stack:new()
end

-- Fill stacks
for i = 1, #initialState-1 do
    for j = 1, stackCount do
      letter = string.sub(initialState[i], 4 * j - 2, 4 * j - 2)
      if letter ~= " " then
        stacks[j]:push(letter)
      end
    end
end

for i = 1, #stacks do
  stacks[i] = stacks[i]:reverse()
end

stacks2 = deepcopy(stacks)

print("Initial state:")
for i = 1, stackCount do
    print("Stack "..i..": "..table.concat(stacks[i], " "))
end

-- Perform moves

-- Part 1

for i = 1, #moves do
    move = Split(moves[i], " ")
    count = tonumber(move[2])
    from = tonumber(move[4])
    to = tonumber(move[6])

    for j = 1, count do
        stacks[to]:push(stacks[from]:pop())
    end
end

part1 = ""
for i = 1, stackCount do
    part1 = part1..stacks[i]:top()
end

print("Part 1: "..part1)

-- print("Final state:")
-- for i = 1, stackCount do
--     print("Stack "..i..": "..table.concat(stacks[i], " "))
-- end

-- Part 2
for i = 1, #moves do
    move = Split(moves[i], " ")
    count = tonumber(move[2])
    from = tonumber(move[4])
    to = tonumber(move[6])
  
    temp = Stack:new()
    for j = 1, count do
        temp:push(stacks2[from]:pop())
    end
    -- print("Move "..i..": "..table.concat(temp, " "))
    for j = 1, count do
        stacks2[to]:push(temp:pop())
    end
end

part2 = ""
for i = 1, stackCount do
    part2 = part2..stacks2[i]:top()
end

print("Part 2: "..part2)
