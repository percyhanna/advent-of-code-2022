lines = File.read("./input.txt").lines

def priority(item)
  case item
  when "a".."z"
    item.ord - 96
  when "A".."Z"
    item.ord - 38
  end
end

total = lines.map(&:chomp).each_slice(3).map do |group|
  shared = group.map(&:chars).reduce(&:&)

  raise "Invalid shared #{[first, second, shared].inspect}" unless shared.length == 1

  priority(shared.first)
end.sum

puts total
