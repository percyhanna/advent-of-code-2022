class Row
  attr_reader :width

  def initialize(width)
    @width = width
    @cells = Array.new(width, false)
  end

  def [](x)
    raise "#{x} is beyond width" if x > width

    @cells[x]
  end

  def []=(x, value)
    @cells[x] = value
  end

  def to_s
    "|#{@cells.map { |cell| cell ? '#' : ' ' }.join("")}|"
  end
end
