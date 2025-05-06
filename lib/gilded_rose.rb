class Sulfuras
  def initialize(item)
    @item = item
  end

  def update
    # Sulfuras does not change in quality or sell_in
  end
end

class BackstagePass
  def initialize(item)
    @item = item
  end

  def update
    if @item.quality < 50
      @item.quality += 1
      @item.quality += 1 if @item.sell_in < 11 && @item.quality < 50
      @item.quality += 1 if @item.sell_in < 6 && @item.quality < 50
    end
    @item.sell_in -= 1
    @item.quality = 0 if @item.sell_in < 0
  end
end

class AgedBrie
  def initialize(item)
    @item = item
  end

  def update
    @item.quality += 1 if @item.quality < 50
    @item.sell_in -= 1
    @item.quality += 1 if @item.sell_in < 0 && @item.quality < 50
  end
end

class NormalItem
  def initialize(item)
    @item = item
  end

  def update
    @item.quality -= 1 if @item.quality > 0
    @item.sell_in -= 1
    @item.quality -= 1 if @item.sell_in < 0 && @item.quality > 0
  end
end

class ConjuredItem
  def initialize(item)
    @item = item
  end

  def update
    @item.quality -= 2 if @item.quality > 0
    @item.sell_in -= 1
    @item.quality -= 2 if @item.sell_in < 0 && @item.quality > 0
    @item.quality = 0 if @item.quality < 0
  end
end

class ItemFactory
  def self.create(item)
    case item.name
    when 'Sulfuras, Hand of Ragnaros'
      Sulfuras.new(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePass.new(item)
    when 'Aged Brie'
      AgedBrie.new(item)
    when /^Conjured/
      ConjuredItem.new(item)
    else
      NormalItem.new(item)
    end
  end
end

def update_quality(items)
  items.each { |item| ItemFactory.create(item).update }
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)

