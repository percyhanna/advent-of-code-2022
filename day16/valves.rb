VALVE_REGEXP = /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? (.*)/

lines = File.read("./input.txt").lines.map(&:chomp)

valves = lines.map do |line|
  if (match = VALVE_REGEXP.match(line))
    [
      match[1],
      {
        valve: match[1],
        flow_rate: match[2].to_i,
        tunnels: match[3].split(", "),
      }
    ]
  else
    puts "Invalid line: #{line}"
  end
end.to_h
