class CoordSpace
  attr_reader :x_range, :y_range, :z_range

  def initialize(x_range, y_range, z_range)
    @x_range = x_range
    @y_range = y_range
    @z_range = z_range
  end

  def include?(x, y, z)
    @x_range.include?(x) &&
    @y_range.include?(y) &&
    @z_range.include?(z)
  end

  def empty_neighbours(coord, space)
    Cube.neighbours_for_coord(*coord).select do |neighbour|
      include?(*neighbour) && !space.key?(neighbour)
    end.to_set
  end

  def count
    x_range.count * y_range.count * z_range.count
  end

  def coordinates
    Enumerator.new do |yielder|
      x_range.each do |x|
        y_range.each do |y|
          z_range.each do |z|
            yielder << [x, y, z]
          end
        end
      end
    end
  end
end
