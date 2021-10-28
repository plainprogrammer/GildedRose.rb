def adjust_quality(item, amount)
  return if amount > 0 && item.quality == 50
  return if amount < 0 && item.quality == 0

  item.quality += amount
end

def decrement_sell_in(item)
  item.sell_in -= 1
end

def update(item)
  case item.name
  when 'Aged Brie'
    adjust_quality(item, 1)
    decrement_sell_in(item)
    adjust_quality(item, 1) if item.sell_in < 0
  when 'Backstage passes to a TAFKAL80ETC concert'
    adjust_quality(item, 1)
    adjust_quality(item, 1) if item.sell_in < 11
    adjust_quality(item, 1) if item.sell_in < 6
    decrement_sell_in(item)
    adjust_quality(item, -item.quality) if item.sell_in < 0
  when 'Sulfuras, Hand of Ragnaros'
    # No-Op
  else
    adjust_quality(item, -1)
    decrement_sell_in(item)
    adjust_quality(item, -1) if item.sell_in < 0
  end
end

def update_quality(items)
  items.each(&method(:update))
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
