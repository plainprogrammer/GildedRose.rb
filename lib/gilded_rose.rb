def adjust_quality(item, amount)
  return if amount > 0 && item.quality == 50
  return if amount < 0 && item.quality == 0

  item.quality += amount
end

def decrement_sell_in(item)
  item.sell_in -= 1
end

def update_quality(items)
  items.each do |item|
    case item.name
    when 'Aged Brie'
      adjust_quality(item, 1)
      decrement_sell_in(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      adjust_quality(item, 1)
      if item.sell_in < 11
        adjust_quality(item, 1)
      end
      if item.sell_in < 6
        adjust_quality(item, 1)
      end
      decrement_sell_in(item)
    when 'Sulfuras, Hand of Ragnaros'
      # No-Op
    else
      adjust_quality(item, -1)
      decrement_sell_in(item)
    end

    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.name != 'Sulfuras, Hand of Ragnaros'
            adjust_quality(item, -1)
          end
        else
          adjust_quality(item, -item.quality)
        end
      else
        adjust_quality(item, 1)
      end
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
