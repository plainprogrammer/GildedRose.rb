def adjust_quality(item, amount)
  item.quality += amount
end

def update_quality(items)
  items.each do |item|
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality > 0
        if item.name != 'Sulfuras, Hand of Ragnaros'
          adjust_quality(item, -1)
        end
      end
    else
      if item.quality < 50
        adjust_quality(item, 1)
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in < 11
            if item.quality < 50
              adjust_quality(item, 1)
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              adjust_quality(item, 1)
            end
          end
        end
      end
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in -= 1
    end
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            if item.name != 'Sulfuras, Hand of Ragnaros'
              adjust_quality(item, -1)
            end
          end
        else
          adjust_quality(item, -item.quality)
        end
      else
        if item.quality < 50
          adjust_quality(item, 1)
        end
      end
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
