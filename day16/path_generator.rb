class PathGenerator
  attr_reader :paths

  def initialize(valves)
    @valves = valves.map { |valve| [valve.key, valve] }.to_h
    @paths = {}

    @valves.values.each do |valve|
      valve.tunnels.map! { |tunnel| @valves[tunnel] }
    end
  end

  def valve(key)
    @valves[key]
  end

  def generate_paths!
    @paths = {}

    @valves.values.each { |valve| create_paths(valve) }
  end

  def path_to(start, target)
    start = valve(start) if start.is_a?(String)
    target = valve(target) if target.is_a?(String)

    key = [start, target]
    raise "Path not found #{start} to #{target}" unless include?(key)

    @paths[key]
  end


  def add_path(start, target, path)
    key = [start, target]

    if !@paths.key?(key) || path.count < @paths[key].count
      @paths[key] = path
    end
  end

  def include?(path)
    @paths.key?(path)
  end

  private

  def create_paths(valve, current_path: [])
    # Short-circuit paths to self
    add_path(valve, valve, [])

    valve.tunnels.flat_map do |tunnel|
      # next if include?([valve, tunnel])
      next if current_path.include?(tunnel)

      add_path(valve, tunnel, current_path + [tunnel])

      create_paths(tunnel, current_path: current_path + [tunnel]).each do |path|
        # puts "Creating paths from #{valve} to #{tunnel}: #{path.map(&:key)}"
        add_path(valve, path.last, path)
      end + [current_path + [tunnel]]
    end.compact
  end
end
