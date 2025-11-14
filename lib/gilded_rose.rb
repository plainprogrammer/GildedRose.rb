# Helper methods to identify item types
def aged_brie?(item)
  item.name == 'Aged Brie'
end

def sulfuras?(item)
  item.name == 'Sulfuras, Hand of Ragnaros'
end

def backstage_pass?(item)
  item.name == 'Backstage passes to a TAFKAL80ETC concert'
end

def conjured?(item)
  item.name.start_with?('Conjured')
end

# Update methods for specific item types
def update_sulfuras(item)
  # Sulfuras never changes quality or sell_in
end

def update_quality(items)
  items.each do |item|
    # Handle Sulfuras separately (no changes needed)
    if sulfuras?(item)
      update_sulfuras(item)
      next
    end

    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality > 0
        item.quality -= 1
      end
    else
      if item.quality < 50
        item.quality += 1
        if item.name == 'Backstage passes to a TAFKAL80ETC concert'
          if item.sell_in < 11
            if item.quality < 50
              item.quality += 1
            end
          end
          if item.sell_in < 6
            if item.quality < 50
              item.quality += 1
            end
          end
        end
      end
    end
    item.sell_in -= 1
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            item.quality -= 1
          end
        else
          item.quality = item.quality - item.quality
        end
      else
        if item.quality < 50
          item.quality += 1
        end
      end
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
