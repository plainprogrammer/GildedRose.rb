require_relative 'item_updater'

# Handles quality updates for Backstage passes
# Quality increases as concert approaches, drops to 0 after concert
# - More than 10 days: +1 quality
# - 6-10 days: +2 quality
# - 1-5 days: +3 quality
# - After concert (sell_in < 0): quality drops to 0
class BackstagePassUpdater < ItemUpdater
  def update
    decrease_sell_in

    if past_sell_date?
      # Concert is over - quality drops to 0
      item.quality = 0
    elsif item.sell_in < 5
      # Very close to concert (1-5 days): +3 quality
      increase_quality(3)
    elsif item.sell_in < 10
      # Medium close to concert (6-10 days): +2 quality
      increase_quality(2)
    else
      # Long time before concert (>10 days): +1 quality
      increase_quality(1)
    end
  end
end
