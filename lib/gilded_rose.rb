def update_quality(items)
  items.each do |item|
    is_sulfuras = item.name == 'Sulfuras, Hand of Ragnaros'
    is_aged_brie = item.name == 'Aged Brie'
    is_backstage_pass = item.name == 'Backstage passes to a TAFKAL80ETC concert'
    is_conjured = item.name.start_with?('Conjured')

    # Part 1: Update quality based on item type (before sell_in decrement)
    if is_aged_brie
      if item.quality < 50
        item.quality += 1
      end
    elsif is_backstage_pass
      if item.quality < 50
        item.quality += 1
        if item.sell_in < 11 && item.quality < 50
          item.quality += 1
        end
        if item.sell_in < 6 && item.quality < 50
          item.quality += 1
        end
      end
    elsif !is_sulfuras # For normal and conjured items
      if item.quality > 0
        item.quality -= 1
        if is_conjured && item.quality > 0 # Conjured items degrade twice as fast
          item.quality -= 1
        end
      end
    end
    # Sulfuras quality does not change.

    # Part 2: Update SellIn date (for non-Sulfuras items)
    if !is_sulfuras
      item.sell_in -= 1
    end

    # Part 3: Update quality based on expiry (sell_in < 0), for non-Sulfuras items
    if item.sell_in < 0
      if is_aged_brie
        if item.quality < 50
          item.quality += 1 # Aged Brie continues to improve
        end
      elsif is_backstage_pass
        item.quality = 0 # Backstage pass quality drops to 0
      elsif !is_sulfuras # For normal and conjured items
        if item.quality > 0
          item.quality -= 1 # Additional degradation for normal items
          if is_conjured && item.quality > 0 # Conjured items degrade twice as fast again
            item.quality -= 1
          end
        end
      end
      # Sulfuras quality does not change post-expiry as its sell_in doesn't change.
    end
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
