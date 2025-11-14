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

def update_aged_brie(item)
  item.sell_in -= 1

  # Increase quality by 1 (or 2 if past sell date)
  increase = item.sell_in < 0 ? 2 : 1
  item.quality = [item.quality + increase, 50].min
end

def update_quality(items)
  items.each do |item|
    # Handle Sulfuras separately (no changes needed)
    if sulfuras?(item)
      update_sulfuras(item)
      next
    end

    # Handle Aged Brie
    if aged_brie?(item)
      update_aged_brie(item)
      next
    end

    # Handle Backstage passes
    if backstage_pass?(item)
      if item.quality < 50
        item.quality += 1
        if item.sell_in < 11 && item.quality < 50
          item.quality += 1
        end
        if item.sell_in < 6 && item.quality < 50
          item.quality += 1
        end
      end
      item.sell_in -= 1
      if item.sell_in < 0
        item.quality = 0
      end
      next
    end

    # Handle normal items (including conjured, for now)
    if item.quality > 0
      item.quality -= 1
    end
    item.sell_in -= 1
    if item.sell_in < 0 && item.quality > 0
      item.quality -= 1
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
