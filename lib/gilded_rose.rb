require 'delegate'

class ItemDecorator < SimpleDelegator
  def self.decorate(item)
    case item.name
    when 'Aged Brie'
      AgedBrie.new(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePass.new(item)
    when 'Sulfuras, Hand of Ragnaros'
      LegendaryItem.new(item)
    when 'Conjured Mana Cake'
      ConjuredItem.new(item)
    else
      ItemDecorator.new(item)
    end
  end

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

class ConjuredItem < ItemDecorator
  def update
    decrement_quality
    decrement_quality
    decrement_sell_in
    decrement_quality if self.sell_in < 0
    decrement_quality if self.sell_in < 0
  end
end

def update_quality(items)
  items.each do |item|
    ItemDecorator.decorate(item).update
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
