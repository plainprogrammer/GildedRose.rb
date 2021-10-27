class ItemDecorator < SimpleDelegator
  def decrement_quality
    self.quality -= 1
  end

  def increment_quality
    self.quality += 1
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

    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality > 0
        if item.name != 'Sulfuras, Hand of Ragnaros'
          item.decrement_quality
        end
      end
    else
      if item.quality < 50
        item.increment_quality

        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in < 11
            if item.quality < 50
              item.increment_quality
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              item.increment_quality
            end
          end
        end
      end
    end
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.decrement_sell_in
    end
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            if item.name != 'Sulfuras, Hand of Ragnaros'
              item.decrement_quality
            end
          end
        else
          item.zero_out_quality
        end
      else
        if item.quality < 50
          item.increment_quality
        end
      end
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
