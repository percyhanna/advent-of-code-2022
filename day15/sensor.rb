def expand_range(range, by: 1)
  Range.new(
    range.begin - by,
    range.end + by
  )
end

class Sensor
  PARSER = %r(Sensor at x=(?<sensor_x>\d+), y=(?<sensor_y>\d+): closest beacon is at x=(?<beacon_x>-?\d+), y=(?<beacon_y>-?\d+))

  attr_reader :sensor_x, :sensor_y, :beacon_x, :beacon_y

  def self.parse_line(line)
    if (match = PARSER.match(line))
      new(
        sensor_x: match.named_captures["sensor_x"].to_i,
        sensor_y: match.named_captures["sensor_y"].to_i,
        beacon_x: match.named_captures["beacon_x"].to_i,
        beacon_y: match.named_captures["beacon_y"].to_i
      )
    else
      raise "Invalid line! #{line}"
    end
  end

  def initialize(sensor_x:, sensor_y:, beacon_x:, beacon_y:)
    @sensor_x = sensor_x
    @sensor_y = sensor_y
    @beacon_x = beacon_x
    @beacon_y = beacon_y
  end

  def distance
    (@sensor_x - @beacon_x).abs + (@sensor_y - @beacon_y).abs
  end

  def x_range
    Range.new(@sensor_x - distance, @sensor_x + distance)
  end

  def y_range
    Range.new(@sensor_y - distance, @sensor_y + distance)
  end

  def coords
    Enumerator.new do |yielder|
      (-distance..distance).each do |y_offset|
        spread = distance - y_offset.abs
        y = @sensor_y + y_offset

        expand_range(Range.new(@sensor_x, @sensor_x), by: spread).each do |x|
          if sensor_x == x && sensor_y == y
            # puts "Skipping (#{sensor_x}, #{sensor_y}) because that's where the sensor is"
          elsif beacon_x == x && beacon_y == y
            # puts "Skipping (#{beacon_x}, #{beacon_y}) because that's where the beacon is"
          else
            yielder << [x, y]
          end
        end
      end
    end
  end
end
