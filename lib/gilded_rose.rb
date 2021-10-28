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
    when 'Aged Brie'
      item.increment_quality
    when 'Backstage passes to a TAFKAL80ETC concert'
      item.increment_quality
      if item.sell_in < 11
        item.increment_quality
      end
      if item.sell_in < 6
        item.increment_quality
      end
    end

    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.decrement_sell_in
    end

    if item.sell_in < 0
      case item.name
      when "Aged Brie"
        item.increment_quality
      when 'Backstage passes to a TAFKAL80ETC concert'
        item.zero_out_quality
      when 'Sulfuras, Hand of Ragnaros'
        # No-Op
      else
        item.decrement_quality
      end
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
