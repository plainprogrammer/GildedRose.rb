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
    when /^Aged Brie$/
      AgedBrieUpdater.new(item)
    when /^Backstage passes/
      BackstagePassUpdater.new(item)
    when /^Sulfuras/
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
    update_quality_after_sell_in if expired?
  end

  protected

  attr_reader :item

  def update_quality
    # Default implementation does nothing
  end

  def update_sell_in
    item.sell_in -= 1 unless sulfuras?
  end

  def update_quality_after_sell_in
    # Default implementation does nothing
  end

  def expired?
    item.sell_in < 0
  end

  def decrease_quality(amount = 1)
    item.quality = [item.quality - amount, MIN_QUALITY].max
  end

  def increase_quality(amount = 1)
    item.quality = [item.quality + amount, MAX_QUALITY].min
  end

  def reset_quality
    item.quality = 0
  end

  def sulfuras?
    item.name.include?('Sulfuras')
  end
end

class NormalItemUpdater < ItemUpdater
  def update_quality
    decrease_quality
  end

  def update_quality_after_sell_in
    decrease_quality
  end
end

class AgedBrieUpdater < ItemUpdater
  def update_quality
    increase_quality
  end

  def update_quality_after_sell_in
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

  def update_quality_after_sell_in
    reset_quality
  end
end

class SulfurasUpdater < ItemUpdater
  def update_quality
    # Sulfuras never changes quality
  end

  def update_sell_in
    # Sulfuras never changes sell_in
  end

  def update_quality_after_sell_in
    # Sulfuras never changes quality
  end
end

class ConjuredItemUpdater < ItemUpdater
  def update_quality
    decrease_quality(2)
  end

  def update_quality_after_sell_in
    decrease_quality(2)
  end
end
