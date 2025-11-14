require_relative 'item_updater'

# Handles quality updates for Sulfuras
# Sulfuras is a legendary item that never changes in quality or sell_in
class SulfurasUpdater < ItemUpdater
  def update
    # Sulfuras never changes - do nothing
  end
end
