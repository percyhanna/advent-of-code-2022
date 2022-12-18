class Shape
  attr_reader :rows

  def initialize(shape)
    @rows = shape.lines.map(&:chomp).map do |line|
      line.chars.map { |c| c == '#' }
    end
  end

  def height
    @height ||= rows.count
  end

  def width
    @width ||= rows.map(&:length).max
  end

  def to_s
    rows.map { |r| r.map { |c| c ? '#' : ' ' }.join("") }.join("\n")
  end

  def blocks
    @blocks ||= Array.new.tap do |arr|
      rows.reverse.each_with_index do |row, y|
        row.each_with_index do |block, x|
          arr << [x, y] if block
        end
      end
    end
  end
end
