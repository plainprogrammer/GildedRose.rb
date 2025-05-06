AGED_BRIE = 'Aged Brie'
BACKSTAGE_PASSES = 'Backstage passes to a TAFKAL80ETC concert'
SULFURAS = 'Sulfuras, Hand of Ragnaros'
CONJURED_PREFIX = 'Conjured '

def aged_brie?(item)
  item.name == AGED_BRIE
end

def backstage_pass?(item)
  item.name == BACKSTAGE_PASSES
end

def sulfuras?(item)
  item.name == SULFURAS
end

def conjured?(item)
  item.name.start_with?(CONJURED_PREFIX)
end

def decrease_quality(item, amount = 1)
  return if sulfuras?(item)
  item.quality = [item.quality - amount, 0].max
end

def increase_quality(item, amount = 1)
  return if sulfuras?(item)
  item.quality = [item.quality + amount, 50].min
end

def decrement_sell_in(item)
  return if sulfuras?(item)
  item.sell_in -= 1
end

def adjust_quality(item)
  if !aged_brie?(item) && !backstage_pass?(item)
    if conjured?(item)
      decrease_quality(item, 2)
    else
      decrease_quality(item)
    end
  else
    if item.quality < 50
      increase_quality(item)
      if backstage_pass?(item)
        if item.sell_in < 11
          increase_quality(item)
        end
        if item.sell_in < 6
          increase_quality(item)
        end
      end
    end
  end
end

def handle_expired(item)
  return unless item.sell_in < 0
  if aged_brie?(item)
    increase_quality(item)
  elsif backstage_pass?(item)
    item.quality = 0
  else
    if conjured?(item)
      decrease_quality(item, 2)
    else
      decrease_quality(item)
    end
  end
end

def update_item(item)
  adjust_quality(item)
  decrement_sell_in(item)
  handle_expired(item)
end

def update_quality(items)
  items.each { |item| update_item(item) }
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
