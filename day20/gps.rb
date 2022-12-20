lines = File.read("./test-input.txt").lines.map(&:chomp).map { |num| num.to_i * 811589153 }
lines = File.read("./input.txt").lines.map(&:chomp).map { |num| num.to_i * 811589153 }

ordered_lines = lines.each_with_index.map { |num, i| [num, i] }
orig_lines = ordered_lines.dup

10.times do
  orig_lines.each do |tuple|
    number, order = tuple
    next if number == 0

    index = ordered_lines.index { |(num, ord)| ord == order }
    ordered_lines.delete_at(index)

    new_index = (index + number) % ordered_lines.count
    ordered_lines.insert(new_index, tuple)
  end
end

offset_0 = ordered_lines.index { |(num, ord)| num == 0 }
code = [1_000, 2_000, 3_000].map do |offset|
  ordered_lines[(offset + offset_0) % ordered_lines.count][0]
end

puts code.inspect
puts code.sum.inspect
