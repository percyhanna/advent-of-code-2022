class Cycler
  attr_reader :count, :counter

  def initialize(items)
    @items = items
    @count = @items.count
    @counter = 0
  end

  def next
    item = @items[@counter % @count]
    @counter += 1
    item
  end

  def skip(count)
    @counter += count
  end
end
