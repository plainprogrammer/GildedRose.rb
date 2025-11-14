# Base class for item quality updaters
# Provides common quality constraint logic for all item types
class ItemUpdater
  MAX_QUALITY = 50
  MIN_QUALITY = 0

  def initialize(item)
    @item = item
  end

  # Template method to update item - to be implemented by subclasses
  def update
    raise NotImplementedError, "#{self.class} must implement #update"
  end

  protected

  attr_reader :item

  # Ensures quality stays within valid bounds (0-50)
  def constrain_quality
    item.quality = MAX_QUALITY if item.quality > MAX_QUALITY
    item.quality = MIN_QUALITY if item.quality < MIN_QUALITY
  end

  # Decreases item quality by specified amount
  def decrease_quality(amount = 1)
    item.quality -= amount
    constrain_quality
  end

  # Increases item quality by specified amount
  def increase_quality(amount = 1)
    item.quality += amount
    constrain_quality
  end

  # Decreases sell_in by 1 day
  def decrease_sell_in
    item.sell_in -= 1
  end

  # Returns true if sell date has passed
  def past_sell_date?
    item.sell_in < 0
  end
end
