require "set"
require "./cube"
require "./coord_space"

lines = File.read("./input.txt").lines.map(&:chomp)

cubes = lines.map { |line| Cube.new(*line.split(",").map(&:to_i)) }

space = {}
cubes.each { |cube| space[cube.coords] = cube }

exposed_sides = cubes.map do |cube|
  cube.exposed_sides(space)
end.sum

puts exposed_sides

def expand_range(range, by: 1)
  Range.new(
    range.begin - by,
    range.end + by
  )
end

coord_space = CoordSpace.new(
  expand_range(Range.new(*cubes.map(&:x).minmax)),
  expand_range(Range.new(*cubes.map(&:y).minmax)),
  expand_range(Range.new(*cubes.map(&:z).minmax))
)

empty_spaces = Set.new

# Find an empty coord
empty_coord = coord_space.coordinates.find { |coord| !space.key?(coord) }
coord_queue = [empty_coord].to_set

loop do
  prev_count = empty_spaces.count
  pending_coords = Set.new
  coord_queue.each do |coord|
    empty_neighbours = coord_space.empty_neighbours(coord, space) - empty_spaces
    empty_spaces += empty_neighbours
    pending_coords += empty_neighbours
  end

  puts "Pending coords: #{pending_coords.count}"

  coord_queue = pending_coords
  puts "Processed empty neighbours, total at: #{empty_spaces.count}"

  break if prev_count == empty_spaces.count
end

cube_coords = space.keys
exposed_surfaces = empty_spaces.map do |empty_coord|
  (Cube.neighbours_for_coord(*empty_coord) & cube_coords).count
end.sum

puts "Exposed surfaces: #{exposed_surfaces}"
