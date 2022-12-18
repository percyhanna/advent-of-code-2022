class Cycler
  def initialize(items)
    @items = items
    @count = @items.count
    @offset = 0
  end

  def next
    item = @items[@offset]
    if @offset + 1 >= @count
      @offset = 0
    else
      @offset += 1
    end

    item
  end
end
