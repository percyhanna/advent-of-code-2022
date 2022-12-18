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
    remaining_rocks = rocks - initial_batch

    raise "Not enough rocks" if remaining_rocks < 0

    initial_batch.times do
      throw_rock
    end

    # Inspect the generated lines, ignoring 20 lines on each end (for it to normalize)
    sampled_lines = to_s.lines[20..-20]

    # Start with a 10 line sample
    search_lines = sampled_lines[0..20]
    next_offset = sampled_lines.count.times.find do |offset|
      next if offset.zero?

      search_lines.each_with_index.all? { |line, index| sampled_lines[index + offset] == line }
    end

    raise "No pattern found" unless next_offset

    puts "Found repetition offset at #{next_offset.inspect}"

    # Start off with a known reptition of the sample
    puts "Before starting: #{remaining_rocks}"
    next_offset.times.find do |i|
      if matches_sample?(search_lines)
        puts "Found the repetition!"
        next true
      end

      throw_rock
      remaining_rocks -= 1

      false
    end
    puts "After starting: #{remaining_rocks}"

    # Find out how many rocks create the pattern
    rock_count = next_offset.times.find do |i|
      throw_rock
      remaining_rocks -= 1

      matches_sample?(search_lines)
    end

    raise "Could not find rock count per repetition" unless rock_count

    puts "Rock count per repetition is #{rock_count}"

    # Process remaining rocks
    repeated_count = remaining_rocks / next_offset - 1

    puts "Pattern is repeated another #{repeated_count} times"

    # Now fake the repetition


    # rocks.times do |i|
    #   throw_rock

    #   if i % log_multiple == 0
    #     log("#{i / log_multiple}:\t#{Time.now.to_f}\t#{(Time.now.to_f - last_cycle) / log_multiple}\t#{height}")
    #     last_cycle = Time.now.to_f
    #   end

    #   # log to_s
    # end
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
