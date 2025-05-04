def adjust_quality(item, amount)
  item.quality += amount
  item.quality = 50 if item.quality > 50
  item.quality = 0 if item.quality < 0
end

def decrement_sell_in(item)
  item.sell_in -= 1
end

UPDATERS = {
  normal: Proc.new { |item|
    decrement_sell_in(item)
    if item.sell_in < 0
      adjust_quality(item, -2)
    else
      adjust_quality(item, -1)
    end
  },
  backstage_pass: Proc.new { |item|
    decrement_sell_in(item)
    if item.sell_in < 0
      adjust_quality(item, -item.quality)
    elsif item.sell_in >= 10
      adjust_quality(item, 1)
    elsif item.sell_in >= 5
      adjust_quality(item, 2)
    else
      adjust_quality(item, 3)
    end
  },
  aged_brie: Proc.new { |item|
    decrement_sell_in(item)
    if item.sell_in < 0
      adjust_quality(item, 2)
    else
      adjust_quality(item, 1)
    end
  },
  legendary: Proc.new {|_item|},
  conjured: Proc.new { |item|
    decrement_sell_in(item)
    if item.sell_in < 0
      adjust_quality(item, -4)
    else
      adjust_quality(item, -2)
    end
  }
}

ITEM_TYPE_MAP = {
  'Sulfuras, Hand of Ragnaros': :legendary,
  'Aged Brie': :aged_brie,
  'Backstage passes to a TAFKAL80ETC concert': :backstage_pass,
  'Conjured Mana Cake': :conjured
}

def lookup_item_type(item)
  ITEM_TYPE_MAP[item.name.to_sym] || :normal
end

def update(item)
  UPDATERS[lookup_item_type(item)].call(item)
end

def update_quality(items)
  items.each(&method(:update))
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
