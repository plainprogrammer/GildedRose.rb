def adjust_quality(item, amount)
  item.quality += amount
  item.quality = 50 if item.quality > 50
  item.quality = 0 if item.quality < 0
end

def decrement_sell_in(item)
  item.sell_in -= 1
end

def update(item)
  return if item.name == 'Sulfuras, Hand of Ragnaros'

  decrement_sell_in(item)

  case item.name
  when 'Aged Brie'
    if item.sell_in < 0
      adjust_quality(item, 2)
    else
      adjust_quality(item, 1)
    end
  when 'Backstage passes to a TAFKAL80ETC concert'
    if item.sell_in < 0
      adjust_quality(item, -item.quality)
    elsif item.sell_in >= 10
      adjust_quality(item, 1)
    elsif item.sell_in >= 5
      adjust_quality(item, 2)
    else
      adjust_quality(item, 3)
    end
  else # Normal Item
    if item.sell_in < 0
      adjust_quality(item, -2)
    else
      adjust_quality(item, -1)
    end
  end
end

def update_quality(items)
  items.each(&method(:update))
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
