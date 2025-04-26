def update_quality(items)
  items.each do |item|
    # Skip Sulfuras updates
    next if item.name == 'Sulfuras, Hand of Ragnaros'

    # Update sell_in for non-legendary items
    item.sell_in -= 1

    # Handle quality updates based on item type
    case item.name
    when 'Aged Brie'
      increase = (item.sell_in < 0) ? 2 : 1
      item.quality += increase
    when 'Backstage passes to a TAFKAL80ETC concert'
      if item.sell_in < 0
        item.quality = 0
      elsif item.sell_in < 5
        item.quality += 3
      elsif item.sell_in < 10
        item.quality += 2
      else
        item.quality += 1
      end
    else # Normal and Conjured items
      decrease = (item.sell_in < 0) ? 2 : 1
      decrease *= 2 if item.name.start_with?('Conjured') # Conjured items degrade twice as fast
      item.quality -= decrease
    end

    # Apply quality constraints (0 <= quality <= 50)
    item.quality = [[item.quality, 0].max, 50].min
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)

