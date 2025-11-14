require 'rspec'
require 'lib/gilded_rose'
require 'lib/updater_factory'

RSpec.describe UpdaterFactory do
  describe '.create' do
    context 'with normal item' do
      let(:item) { Item.new('Normal Item', 10, 20) }

      it 'creates a NormalItemUpdater' do
        updater = UpdaterFactory.create(item)
        expect(updater).to be_a(NormalItemUpdater)
      end
    end

    context 'with Aged Brie' do
      let(:item) { Item.new('Aged Brie', 10, 20) }

      it 'creates an AgedBrieUpdater' do
        updater = UpdaterFactory.create(item)
        expect(updater).to be_a(AgedBrieUpdater)
      end
    end

    context 'with Sulfuras' do
      let(:item) { Item.new('Sulfuras, Hand of Ragnaros', 10, 80) }

      it 'creates a SulfurasUpdater' do
        updater = UpdaterFactory.create(item)
        expect(updater).to be_a(SulfurasUpdater)
      end
    end

    context 'with Backstage pass' do
      let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', 10, 20) }

      it 'creates a BackstagePassUpdater' do
        updater = UpdaterFactory.create(item)
        expect(updater).to be_a(BackstagePassUpdater)
      end
    end

    context 'with unknown item' do
      let(:item) { Item.new('Unknown Item Type', 10, 20) }

      it 'creates a NormalItemUpdater as default' do
        updater = UpdaterFactory.create(item)
        expect(updater).to be_a(NormalItemUpdater)
      end
    end
  end
end
