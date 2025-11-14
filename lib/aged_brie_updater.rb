require_relative 'item_updater'

# Handles quality updates for Aged Brie
# Aged Brie increases in quality over time (1 before sell date, 2 after)
class AgedBrieUpdater < ItemUpdater
  def update
    decrease_sell_in

    if past_sell_date?
      increase_quality(2)
    else
      increase_quality(1)
    end
  end
end
