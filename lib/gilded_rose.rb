def update_quality(items)
  items.each do |item|
    case item.name
    when 'Aged Brie'
      update_aged_brie(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      update_backstage_pass(item)
    when 'Sulfuras, Hand of Ragnaros'
      # Legendary items never change
    else
      update_regular_item(item)
    end
  end
end

def update_aged_brie(item)
  increase_quality(item)
  item.sell_in -= 1
  
  # Quality increases twice as fast after sell date
  increase_quality(item) if item.sell_in < 0
end

def update_backstage_pass(item)
  increase_quality(item)
  
  # Additional quality increases based on sell-in value
  if item.sell_in <= 10
    increase_quality(item)
  end
  
  if item.sell_in <= 5
    increase_quality(item)
  end
  
  item.sell_in -= 1
  
  # Quality drops to 0 after the concert
  if item.sell_in < 0
    item.quality = 0
  end
end

def update_regular_item(item)
  degradation = 1
  
  # Conjured items degrade twice as fast
  if item.name.start_with?('Conjured')
    degradation = 2
  end
  
  decrease_quality(item, degradation)
  item.sell_in -= 1
  
  # Quality degrades twice as fast after sell date
  if item.sell_in < 0
    decrease_quality(item, degradation)
  end
end

def increase_quality(item)
  if item.quality < 50
    item.quality += 1
  end
end

def decrease_quality(item, amount = 1)
  if item.quality > 0
    item.quality -= amount
    # Ensure quality is never negative
    item.quality = 0 if item.quality < 0
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
