class SearchGrid
  attr_reader :rows, :min_x, :max_x

  def initialize
    @min_x = 0
    @max_x = 0
    @rows = Hash.new { |hash, key| hash[key] = {} }
  end

  def add(x, y)
    @rows[y][x] = true

    @min_x = x if x < @min_x
    @max_x = x if x > @max_x
  end

  def line(y)
    (min_x..max_x).map do |x|
      [x, rows[y][x]]
    end.to_h
  end
end
