def update_quality(items)
  items.each do |item|
    ItemUpdater.for(item).update
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)

#----------------------------
# New code below
#----------------------------

class ItemUpdater
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def self.for(item)
    case item.name
    when 'Aged Brie'
      AgedBrieUpdater.new(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePassUpdater.new(item)
    when 'Sulfuras, Hand of Ragnaros'
      SulfurasUpdater.new(item)
    when /^Conjured/
      ConjuredItemUpdater.new(item)
    else
      NormalItemUpdater.new(item)
    end
  end

  def initialize(item)
    @item = item
  end

  def update
    update_quality
    update_sell_in
    update_expired if expired?
  end

  protected

  attr_reader :item

  def update_quality
    # To be implemented by subclasses
  end

  def update_sell_in
    item.sell_in -= 1
  end

  def update_expired
    # To be implemented by subclasses
  end

  def expired?
    item.sell_in < 0
  end

  def increase_quality(amount = 1)
    new_quality = item.quality + amount
    item.quality = [new_quality, MAX_QUALITY].min
  end

  def decrease_quality(amount = 1)
    new_quality = item.quality - amount
    item.quality = [new_quality, MIN_QUALITY].max
  end
end

class NormalItemUpdater < ItemUpdater
  def update_quality
    decrease_quality
  end

  def update_expired
    decrease_quality
  end
end

class AgedBrieUpdater < ItemUpdater
  def update_quality
    increase_quality
  end

  def update_expired
    increase_quality
  end
end

class BackstagePassUpdater < ItemUpdater
  def update_quality
    increase_quality

    if item.sell_in < 11
      increase_quality
    end

    if item.sell_in < 6
      increase_quality
    end
  end

  def update_expired
    item.quality = 0
  end
end

class SulfurasUpdater < ItemUpdater
  def update_quality
    # Quality never changes
  end

  def update_sell_in
    # Sell_in never changes
  end

  def update_expired
    # Nothing happens when expired
  end
end

class ConjuredItemUpdater < ItemUpdater
  def update_quality
    decrease_quality(2)
  end

  def update_expired
    decrease_quality(2)
  end
end
