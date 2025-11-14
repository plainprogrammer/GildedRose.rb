require_relative 'item_updater'

# Handles quality updates for Conjured items
# Conjured items degrade twice as fast as normal items
# - Before sell date: quality decreases by 2
# - After sell date: quality decreases by 4
class ConjuredItemUpdater < ItemUpdater
  def update
    decrease_sell_in

    if past_sell_date?
      decrease_quality(4)
    else
      decrease_quality(2)
    end
  end
end
