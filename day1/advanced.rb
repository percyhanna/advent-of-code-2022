input = File.read("./input.txt")
elves = input.split("\n\n").map { |elf| elf.lines.map { |line| line.chomp.to_i }.sum }

puts elves.sort[-3..].sum

puts elves.max
