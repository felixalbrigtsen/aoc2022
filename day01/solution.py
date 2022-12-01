# The data is a list of calories of each fooditem carried by the elves.
# Each line is one item, just the number of calories.
# Elves are separated by an empty line

DEBUG = False

# Read the input file into a list of elves, each of which is a list of calories
with open("input.txt", "r") as f:
    # Split on empty lines. Each elf into its own string.
    data = f.read()[:-1].split("\n\n")

    # Split on newlines. Each elf into its own array, with each line into its own string.
    data = [x.split("\n") for x in data]
    # Parse data to integer. Same as above, but each line is an integer.
    data = [[int(y) for y in x] for x in data]

if DEBUG: print("All data: ", data)


# Part 1
# Find the Elf carrying the most Calories. How many total Calories is that Elf carrying?

sums = [sum(x) for x in data]
if DEBUG: print("All sums: ", sums)

# Sort the sums
sums.sort()
# print("Sorted sums: ", sums)

print("======")
print("Part 1: ", sums[-1])
print("======")

# Part 2
# Find the top three Elves carrying the most Calories. How many Calories are those Elves carrying in total?

if DEBUG: print("Top 3: ", sums[-3:])

print("======")
print("Part 2: ", sum(sums[-3:]))
print("======")
