class ItemDecorator < SimpleDelegator
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

def update_quality(items)
  items.each do |item|
    item = ItemDecorator.new(item)

    case item.name
    when 'NORMAL ITEM'
      item.decrement_quality
      item.decrement_sell_in
      item.decrement_quality if item.sell_in < 0
    when 'Aged Brie'
      item.increment_quality
      item.decrement_sell_in
      item.increment_quality if item.sell_in < 0
    when 'Backstage passes to a TAFKAL80ETC concert'
      item.increment_quality
      if item.sell_in < 11
        item.increment_quality
      end
      if item.sell_in < 6
        item.increment_quality
      end
      item.decrement_sell_in
      item.zero_out_quality if item.sell_in < 0
    else # Legendary Items
      # No-Op
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
