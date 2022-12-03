lines = File.read("./input.txt").lines

def priority(item)
  case item
  when "a".."z"
    item.ord - 96
  when "A".."Z"
    item.ord - 38
  end
end

total = lines.map do |line|
  line.chomp!
  length = line.chomp.length
  first = line[0..(length/2 - 1)]
  second = line[(length/2)..]

  shared = first.chars & second.chars

  raise "Invalid shared #{[first, second, shared].inspect}" unless shared.length == 1
  priority(shared.first)
end.sum


puts total
