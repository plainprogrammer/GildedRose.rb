def update_quality(items)
  items.each do |item|
    updater = ItemUpdater.for(item)
    updater.update
  end
end

# Helper class to encapsulate update logic for different item types
class ItemUpdater
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  attr_reader :item

  def self.for(item)
    case item.name
    when 'Aged Brie'
      AgedBrieUpdater.new(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePassUpdater.new(item)
    when 'Sulfuras, Hand of Ragnaros'
      SulfurasUpdater.new(item)
    when /^Conjured/ # Match names starting with "Conjured"
      ConjuredItemUpdater.new(item)
    else
      NormalItemUpdater.new(item)
    end
  end

  def initialize(item)
    @item = item
  end

  # Default update behavior (for normal items)
  def update
    decrease_sell_in
    decrease_quality
    decrease_quality if expired?
  end

  protected

  def decrease_sell_in
    item.sell_in -= 1
  end

  def expired?
    item.sell_in < 0
  end

  def increase_quality(amount = 1)
    item.quality = [item.quality + amount, MAX_QUALITY].min
  end

  def decrease_quality(amount = 1)
    item.quality = [item.quality - amount, MIN_QUALITY].max
  end
end

class AgedBrieUpdater < ItemUpdater
  def update
    decrease_sell_in
    increase_quality
    increase_quality if expired?
  end
end

class BackstagePassUpdater < ItemUpdater
  def update
    decrease_sell_in
    if expired?
      item.quality = 0
    else
      increase_quality
      increase_quality if item.sell_in < 10
      increase_quality if item.sell_in < 5
    end
  end
end

class SulfurasUpdater < ItemUpdater
  # Sulfuras never changes
  def update; end
end

class NormalItemUpdater < ItemUpdater
  # Uses default update logic
end

class ConjuredItemUpdater < ItemUpdater
  # Conjured items degrade twice as fast
  def update
    decrease_sell_in
    decrease_quality(2)
    decrease_quality(2) if expired?
  end
end


#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
