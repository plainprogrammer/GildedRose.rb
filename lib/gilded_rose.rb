# Item type predicates (pure functions)
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

def normal_item?(item)
  !aged_brie?(item) && !sulfuras?(item) && !backstage_pass?(item) && !conjured?(item)
end

# Quality calculation helpers (pure functions)
def clamp_quality(quality)
  [[quality, 0].max, 50].min
end

def calculate_normal_quality(quality, sell_in)
  degradation = sell_in <= 0 ? 2 : 1
  clamp_quality(quality - degradation)
end

def calculate_aged_brie_quality(quality, sell_in)
  improvement = sell_in <= 0 ? 2 : 1
  clamp_quality(quality + improvement)
end

def calculate_backstage_pass_quality(quality, sell_in)
  return 0 if sell_in <= 0

  improvement = case sell_in
  when 1..5 then 3
  when 6..10 then 2
  else 1
  end

  clamp_quality(quality + improvement)
end

def calculate_sulfuras_quality(quality, _sell_in)
  quality # Never changes
end

def calculate_conjured_quality(quality, sell_in)
  degradation = sell_in <= 0 ? 4 : 2
  clamp_quality(quality - degradation)
end

# Sell-in calculation (pure function)
def calculate_sell_in(item)
  sulfuras?(item) ? item.sell_in : item.sell_in - 1
end

# Item update strategy (functional dispatch)
def calculate_new_quality(item)
  quality_calculator = case
  when sulfuras?(item) then method(:calculate_sulfuras_quality)
  when aged_brie?(item) then method(:calculate_aged_brie_quality)
  when backstage_pass?(item) then method(:calculate_backstage_pass_quality)
  when conjured?(item) then method(:calculate_conjured_quality)
  when normal_item?(item) then method(:calculate_normal_quality)
  else method(:calculate_normal_quality)
  end

  quality_calculator.call(item.quality, item.sell_in)
end

def update_item(item)
  new_quality = calculate_new_quality(item)
  new_sell_in = calculate_sell_in(item)

  item.quality = new_quality
  item.sell_in = new_sell_in
  item
end

def update_quality(items)
  items.each do |item|
    if item.name != 'Aged Brie' && item.name != 'Backstage passes to a TAFKAL80ETC concert'
      if item.quality > 0
        if item.name != 'Sulfuras, Hand of Ragnaros'
          item.quality -= 1
        end
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
    if item.name != 'Sulfuras, Hand of Ragnaros'
      item.sell_in -= 1
    end
    if item.sell_in < 0
      if item.name != "Aged Brie"
        if item.name != 'Backstage passes to a TAFKAL80ETC concert'
          if item.quality > 0
            if item.name != 'Sulfuras, Hand of Ragnaros'
              item.quality -= 1
            end
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
