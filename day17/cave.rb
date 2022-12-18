require "./cycler"
require "./row"

class Cave
  attr_reader :rows, :shapes, :jets, :width, :rocks

  def initialize(shapes:, jets:, rocks:, width: 7)
    @height = 0
    @rows = Hash.new { |hash, key| @height = [@height, key + 1].max; hash[key] = Array.new(width, false) }
    @shapes = shapes
    @jets = jets.map { |c| c == ">" }
    @rocks = rocks
    @width = width
  end

  def log(msg)
    puts msg
  end

  def run
    log_multiple = 100_000
    last_cycle = Time.now.to_f

    rocks.times do |i|
      throw_rock

      if i % log_multiple == 0
        log("#{i / log_multiple}:\t#{Time.now.to_f}\t#{(Time.now.to_f - last_cycle) / log_multiple}")
        last_cycle = Time.now.to_f
      end

      # log to_s
    end
  end

  def run_with_optimizations
    log_multiple = 100_000
    last_cycle = Time.now.to_f

    batch_size = 500
    remaining_rocks = rocks - batch_size

    raise "Not enough rocks" if remaining_rocks < 0

    batch_size.times do
      throw_rock
    end

    # Inspect the generated lines, ignoring 20 lines on each end (for it to normalize)
    initial_cave = to_s
    sampled_lines = initial_cave.lines[20..-20]

    # Start with a 20 line sample
    search_lines = sampled_lines[0..20].join
    initial_count = initial_cave.scan(search_lines).count


    # Loop until we get one more repitition
    loop do
      throw_rock
      remaining_rocks -= 1

      break if to_s.scan(search_lines).count > initial_count
    end

    # Now find out how many rocks per reptition
    rocks_per_reptition = 0
    initial_height = @height
    initial_count += 1
    loop do
      throw_rock
      remaining_rocks -= 1
      rocks_per_reptition += 1

      break if to_s.scan(search_lines).count > initial_count

      raise "Ran out of rocks" if remaining_rocks < 0
      raise "Too many rocks" if rocks_per_reptition > 100
    end

    lines_per_reptition = @height - initial_height

    puts "Rocks per repetition: #{rocks_per_reptition}"
    puts "Lines per repetition: #{lines_per_reptition}"

    repitition_count = remaining_rocks / rocks_per_reptition

    # Grab some fake lines!
    fake_lines = 10.times.map do |line|
      @rows[@height - line - 1]
    end


    # Skip ahead!
    @height += repitition_count * lines_per_reptition
    remaining_rocks -= repitition_count * rocks_per_reptition

    # Need to skip ahead on the cyclers, too
    jets_cycle.skip(repitition_count * rocks_per_reptition)
    shapes_cycle.skip(repitition_count * rocks_per_reptition)

    puts "Skipped ahead:    #{repitition_count}"
    puts "New height:       #{@height}"
    puts "Remaining rocks:  #{remaining_rocks}"

    # Add some fake lines
    10.times do |line|
      @rows[@height - line] = fake_lines[line]
    end

    remaining_rocks.times do |i|
      throw_rock
    end
  end

  def matches_sample?(sampled_lines, offset: 5)
    puts sampled_lines.inspect
    puts to_s.lines[offset...(sampled_lines.count + offset)].inspect
    puts

    sampled_lines == to_s.lines[offset...(sampled_lines.count + offset)]
  end

  def height
    @height
  end

  def to_s
    rows.map { |k, row| "|#{row.map { |b| b ? '#' : ' ' }.join("")}|" }.reverse.join("\n")
  end

  private

  def throw_rock
    shape = shapes_cycle.next

    x, y = move_shape(shape)
    place_shape(shape, x, y)
  end

  def move_shape(shape, x: 2, y: height + 3)
    loop do
      # Move left/right
      jet = jets_cycle.next
      next_x = jet ? x + 1 : x - 1
      if can_move_to?(shape, next_x, y)
        # log "Moved #{jet ? "right" : "left"}"
        x = next_x
      else
        # log "Unable to move #{jet ? "right" : "left"}"
      end

      # Move down
      if can_move_to?(shape, x, y - 1)
        # log "Moved down"
        y -= 1
      else
        break
      end
    end

    [x, y]
  end

  def place_shape(shape, x, y)
    # Place the rock at this position
    shape.blocks.each do |(x_offset, y_offset)|
      place_block(x + x_offset, y + y_offset)
    end
  end

  def place_block(x, y)
    rows[y][x] = true
  end

  def can_move_to?(shape, x, y)
    # Dimensions check
    return false if x < 0
    return false if y < 0
    return false if x + shape.width > width

    # Always possible if it's beyond the height of the cave
    return true if y > height

    # Check if any block is blocked
    !shape.blocks.any? do |(x_offset, y_offset)|
      has_block?(x + x_offset, y + y_offset)
    end
  end

  def has_block?(x, y)
    return false if y > @height
    return false unless rows.key?(y)
    rows[y][x]
  end

  def shapes_cycle
    @shapes_cycle ||= Cycler.new(shapes)
  end

  def jets_cycle
    @jets_cycle ||= Cycler.new(jets)
  end
end
