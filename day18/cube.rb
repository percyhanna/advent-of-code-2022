class Cube
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

  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end

  def coords
    [@x, @y, @z]
  end

  def exposed_sides(space)
    EDGE_COORDS.reject do |(x, y, z)|
      space.key?([@x + x, @y + y, @z + z])
    end.count
  end

  def to_s
    "(#{@x}, #{@y}, #{@z})"
  end
end
