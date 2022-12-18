require "./cycler"
require "./row"

class Cave
  attr_reader :rows, :shapes, :jets, :width, :rocks

  def initialize(shapes:, jets:, rocks:, width: 7)
    @rows = Hash.new { |hash, key| hash[key] = Row.new(width) }
    @shapes = shapes
    @jets = jets.map { |c| c == ">" }
    @rocks = rocks
    @width = width
  end

  def log(msg)
    puts msg
  end

  def run
    log_multiple = 1_000
    last_cycle = Time.now.to_f

    rocks.times do |i|
      shape = shapes_cycle.next

      x, y = move_shape(shape)
      place_shape(shape, x, y)

      if i % log_multiple == 0
        log("#{i / log_multiple}:\t#{Time.now.to_f}\t#{(Time.now.to_f - last_cycle) / log_multiple}")
        last_cycle = Time.now.to_f
      end

      # log to_s
    end
  end

  def height
    rows.count
  end

  def to_s
    rows.map { |k, row| "#{k}:\t#{row}" }.reverse.join("\n")
  end

  private

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
    return false if x + shape.width > width
    return false if x < 0
    return false if y < 0

    # Always possible if it's beyond the height of the cave
    return true if y > height

    # Check if any block is blocked
    !shape.blocks.any? do |(x_offset, y_offset)|
      has_block?(x + x_offset, y + y_offset)
    end
  end

  def has_block?(x, y)
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
