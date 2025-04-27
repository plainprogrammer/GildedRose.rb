def update_quality(items)
  items.each do |item|
    if item.name == 'Sulfuras, Hand of Ragnaros'
      next # Skip all updates for Sulfuras
    end

    # Update sell_in for all non-Sulfuras items
    item.sell_in -= 1

    case item.name
    when 'Aged Brie'
      # Aged Brie increases in quality as it gets older
      increase_amount = (item.sell_in < 0) ? 2 : 1
      increase_quality(item, increase_amount)
    when 'Backstage passes to a TAFKAL80ETC concert'
      if item.sell_in < 0
        item.quality = 0 # After concert, quality drops to 0
      else
        # Quality increases based on days remaining
        increase_amount = 1
        increase_amount += 1 if item.sell_in < 10
        increase_amount += 1 if item.sell_in < 5
        increase_quality(item, increase_amount)
      end
    else
      # Normal items and Conjured items decrease in quality
      decrease_amount = (item.sell_in < 0) ? 2 : 1
      
      # "Conjured" items degrade twice as fast
      if item.name.start_with?('Conjured')
        decrease_amount *= 2
      end
      
      decrease_quality(item, decrease_amount)
    end
  end
end

# Helper methods to maintain quality constraints
def increase_quality(item, amount)
  item.quality = [item.quality + amount, 50].min
end

def decrease_quality(item, amount)
  item.quality = [item.quality - amount, 0].max
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
