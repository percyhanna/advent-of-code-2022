require "./valve"
require "./path_generator"

VALVE_REGEXP = /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/

lines = File.read("./test-input.txt").lines.map(&:chomp)

valves = lines.map do |line|
  if (match = VALVE_REGEXP.match(line))
    Valve.new(
      key: match[1],
      flow_rate: match[2].to_i,
      tunnels: match[3].split(", "),
    )
  else
    raise "Invalid line: #{line}"
  end
end

paths = PathGenerator.new(valves)
paths.generate_paths!
