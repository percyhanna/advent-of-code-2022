require "./sensor"
require "./search_grid"

lines = File.read("./input.txt").lines.map(&:chomp)

sensors = lines.map { |line| Sensor.parse_line(line) }

sensor = sensors.find { |sensor| sensor.sensor_x == 8 && sensor.sensor_y == 7 }

search_grid = SearchGrid.new

sensors.each_with_index do |sensor, i|
  sensor.coords.each { |(x, y)| search_grid.add(x, y) }
end

puts search_grid.rows[10].count
