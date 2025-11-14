require_relative 'item_updater'

# Handles quality updates for normal items
# Normal items degrade by 1 before sell date, 2 after
class NormalItemUpdater < ItemUpdater
  def update
    decrease_sell_in

    if past_sell_date?
      decrease_quality(2)
    else
      decrease_quality(1)
    end
  end
end
