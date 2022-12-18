class Cube
  attr_reader :x, :y, :z

  EDGE_COORDS = [
    # X edges
    [1, 0, 0],
    [-1, 0, 0],
    # Y edges
    [0, 1, 0],
    [0, -1, 0],
    # Z edges
    [0, 0, 1],
    [0, 0, -1],
  ]

  def self.neighbours_for_coord(_x, _y, _z)
    EDGE_COORDS.map { |(x, y, z)| [_x + x, _y + y, _z + z] }
  end

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def coords
    [@x, @y, @z]
  end

  def neighbours
    self.class.neighbours_for_coord(*coords)
  end

  def exposed_sides(space, air_pockets: Set.new)
    neighbours.reject { |coord| space.key?(coord) || air_pockets.include?(coord) }.count
  end

  def to_s
    "(#{@x}, #{@y}, #{@z})"
  end
end
