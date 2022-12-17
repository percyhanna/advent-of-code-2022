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

jets = File.read("./jets-test.txt").chomp.chars
cave = Cave.new(shapes: shapes, jets: jets, rocks: 10_000)
# cave = Cave.new(shapes: shapes, jets: jets, rocks: 1_000_000_000_000)

# jets = File.read("./jets.txt").chomp.chars
# cave = Cave.new(shapes: shapes, jets: jets, rocks: 2022)

# cave.run

result = RubyProf.profile do
  cave.run
end

printer = RubyProf::FlatPrinter.new(result)
printer.print(STDOUT)

# printer = RubyProf::GraphPrinter.new(result)
# printer.print(STDOUT, {})


# puts shapes.inspect

puts cave.height
