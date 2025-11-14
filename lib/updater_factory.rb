require_relative 'normal_item_updater'
require_relative 'aged_brie_updater'
require_relative 'sulfuras_updater'
require_relative 'backstage_pass_updater'
require_relative 'conjured_item_updater'

# Factory to create appropriate updater based on item name
class UpdaterFactory
  def self.create(item)
    case item.name
    when 'Aged Brie'
      AgedBrieUpdater.new(item)
    when 'Sulfuras, Hand of Ragnaros'
      SulfurasUpdater.new(item)
    when 'Backstage passes to a TAFKAL80ETC concert'
      BackstagePassUpdater.new(item)
    when /^Conjured/
      ConjuredItemUpdater.new(item)
    else
      NormalItemUpdater.new(item)
    end
  end
end
