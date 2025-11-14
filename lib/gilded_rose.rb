require_relative 'updater_factory'

def update_quality(items)
  items.each do |item|
    updater = UpdaterFactory.create(item)
    updater.update
  end
end

#----------------------------
# DO NOT CHANGE THINGS BELOW
#----------------------------

Item = Struct.new(:name, :sell_in, :quality)
