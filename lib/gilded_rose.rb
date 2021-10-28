class ItemDecorator < SimpleDelegator
  def update
    decrement_quality
    decrement_sell_in
    decrement_quality if self.sell_in < 0
  end

  private

  def decrement_quality
    self.quality -= 1 if self.quality > 0
  end

  def increment_quality
    self.quality += 1 if self.quality < 50
  end

  def decrement_sell_in
    self.sell_in -= 1
  end

  def zero_out_quality
    self.quality = 0
  end
end

class AgedBrie < ItemDecorator
  def update
    increment_quality
    decrement_sell_in
    increment_quality if self.sell_in < 0
  end
end

class BackstagePass < ItemDecorator
  def update
    increment_quality
    increment_quality if self.sell_in < 11
    increment_quality if self.sell_in < 6
    decrement_sell_in
    zero_out_quality if self.sell_in < 0
  end
end

class LegendaryItem < ItemDecorator
  def update; end # No-Op
end

def update_quality(items)
  items.each do |item|
    case item.name
    when 'Aged Brie'
      AgedBrie.new(item).update
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePass.new(item).update
    when 'Sulfuras, Hand of Ragnaros'
      LegendaryItem.new(item).update
    else
      ItemDecorator.new(item).update
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
