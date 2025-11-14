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

def update_backstage_pass(item)
  # Quality increases as sell_in approaches
  # +1 normally, +2 when 10 days or less, +3 when 5 days or less
  # Drops to 0 after the concert
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
end

def update_normal_item(item)
  # Normal items degrade by 1 per day, 2 per day after sell date
  decrease = item.sell_in > 0 ? 1 : 2
  item.quality = [item.quality - decrease, 0].max
  item.sell_in -= 1
end

def update_conjured_item(item)
  # Conjured items degrade twice as fast as normal items
  # 2 per day before sell date, 4 per day after sell date
  decrease = item.sell_in > 0 ? 2 : 4
  item.quality = [item.quality - decrease, 0].max
  item.sell_in -= 1
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
      update_backstage_pass(item)
      next
    end

    # Handle Conjured items
    if conjured?(item)
      update_conjured_item(item)
      next
    end

    # Handle normal items (default case)
    update_normal_item(item)
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
