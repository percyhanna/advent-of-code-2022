# Stacks will be 0-indexed, with the top being at index 0
stacks = []

reading_stacks = true
File.read("./input.txt").lines.map(&:chomp).each do |line|
  if line.empty?
    reading_stacks = false
  elsif line =~ /\A[\s\d]+\z/
    puts "Skipping stack numbers: #{line}"
  elsif reading_stacks
    line = line[1...-1]
    crates = line.chars.each_with_index.select { |c, i| i & 3 == 0 }
    crates.map(&:first).each_with_index do |crate, index|
      next if crate == " "

      stacks[index] ||= []
      stacks[index] << crate
    end
  else
    match = /move (?<qty>\d+) from (?<from>\d+) to (?<to>\d+)/.match(line)

    puts "Move #{match.named_captures["qty"]} from #{match.named_captures["from"]} to #{match.named_captures["to"]}"

    qty = match.named_captures["qty"].to_i
    from = match.named_captures["from"].to_i - 1
    to = match.named_captures["to"].to_i - 1

    qty.times do
      stacks[to].unshift(stacks[from].shift)
    end
  end
end

puts stacks.inspect

puts stacks.map(&:first).join("")
