lines = File.read("./input.txt").lines.map(&:chomp)

covered_lines = lines.select do |line|
  sets = line.split(",")

  first, second = sets.map do |set|
    a, b = set.split("-").map(&:to_i)

    Range.new(a, b)
  end

  shared = first.to_a & second.to_a

  shared.any?
end

puts covered_lines.count
