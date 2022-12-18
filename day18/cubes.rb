require "./cube"

lines = File.read("./input.txt").lines.map(&:chomp)

cubes = lines.map { |line| Cube.new(*line.split(",").map(&:to_i)) }

space = {}
cubes.each { |cube| space[cube.coords] = cube }

exposed_sides = cubes.map do |cube|
  num = cube.exposed_sides(space)
end.sum

puts exposed_sides
