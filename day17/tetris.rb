require "ruby-prof"

require "./shape"
require "./cave"

shapes = [
  <<~LINE,
  ####
  LINE

  <<~PLUS,
  .#.
  ###
  .#.
  PLUS

  <<~L,
  ..#
  ..#
  ###
  L

  <<~BAR,
  #
  #
  #
  #
  BAR

  <<~SQUARE,
  ##
  ##
  SQUARE
].map { |shape| Shape.new(shape) }

# jets = File.read("./jets-test.txt").chomp.chars
# cave = Cave.new(shapes: shapes, jets: jets, rocks: 2022)
# cave = Cave.new(shapes: shapes, jets: jets, rocks: 1_000_000_000_000)

jets = File.read("./jets.txt").chomp.chars
cave = Cave.new(shapes: shapes, jets: jets, rocks: 2022)
cave = Cave.new(shapes: shapes, jets: jets, rocks: 1_000_000_000_000)

begin
  cave.run_with_optimizations(batch_size: 3_000)
end

puts cave.height
