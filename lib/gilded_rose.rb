def adjust_quality(item, amount)
  return if amount > 0 && item.quality == 50
  item.quality += amount if item.quality > 0
end

def decrement_sell_in(item)
  item.sell_in -= 1
end

def update_quality(items)
  items.each do |item|
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.name != 'Sulfuras, Hand of Ragnaros'
        adjust_quality(item, -1)
      end
    else
      adjust_quality(item, 1)
      if item.name == 'Backstage passes to a TAFKAL80ETC concert'
        if item.sell_in < 11
          adjust_quality(item, 1)
        end
        if item.sell_in < 6
          adjust_quality(item, 1)
        end
      end
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
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
