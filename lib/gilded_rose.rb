def update_quality(items)
  items.each do |item|
    updater = ItemUpdaterFactory.create(item)
    updater.update
  end
end

# Factory to create appropriate updater for each item type
class ItemUpdaterFactory
  def self.create(item)
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
      StandardItemUpdater.new(item)
    end
  end
end

# Base updater with common functionality
class ItemUpdater
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def initialize(item)
    @item = item
  end

  def update
    update_quality
    update_sell_in
    update_expired if expired?
  end

  def update_quality
    # Implemented by subclasses
  end

  def update_sell_in
    @item.sell_in -= 1
  end

  def update_expired
    # Implemented by subclasses when needed
  end

  def expired?
    @item.sell_in < 0
  end

  def increase_quality(amount = 1)
    @item.quality = [MAX_QUALITY, @item.quality + amount].min
  end

  def decrease_quality(amount = 1)
    @item.quality = [MIN_QUALITY, @item.quality - amount].max
  end
end

# Standard items decrease in quality by 1
class StandardItemUpdater < ItemUpdater
  def update_quality
    decrease_quality
  end

  def update_expired
    decrease_quality
  end
end

# Aged Brie increases in quality over time
class AgedBrieUpdater < ItemUpdater
  def update_quality
    increase_quality
  end

  def update_expired
    increase_quality
  end
end

# Backstage passes increase in quality as concert approaches
class BackstagePassUpdater < ItemUpdater
  def update_quality
    increase_quality

    if @item.sell_in < 11
      increase_quality
    end

    if @item.sell_in < 6
      increase_quality
    end
  end

  def update_expired
    @item.quality = 0
  end
end

# Sulfuras never changes
class SulfurasUpdater < ItemUpdater
  def update_quality
    # Quality never changes
  end

  def update_sell_in
    # Sell-in never changes
  end

  def update_expired
    # Nothing happens when expired
  end
end

# Conjured items degrade twice as fast
class ConjuredItemUpdater < ItemUpdater
  def update_quality
    decrease_quality(2)
  end

  def update_expired
    decrease_quality(2)
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
