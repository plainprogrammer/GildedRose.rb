require 'rspec'
require 'lib/gilded_rose'
require 'lib/sulfuras_updater'

RSpec.describe SulfurasUpdater do
  let(:item) { Item.new('Sulfuras, Hand of Ragnaros', sell_in, quality) }
  let(:updater) { SulfurasUpdater.new(item) }

  describe '#update' do
    context 'before sell date' do
      let(:sell_in) { 5 }
      let(:quality) { 80 }

      it 'does not change quality' do
        updater.update
        expect(item.quality).to eq(80)
      end

      it 'does not change sell_in' do
        updater.update
        expect(item.sell_in).to eq(5)
      end
    end

    context 'on sell date' do
      let(:sell_in) { 0 }
      let(:quality) { 80 }

      it 'does not change quality' do
        updater.update
        expect(item.quality).to eq(80)
      end

      it 'does not change sell_in' do
        updater.update
        expect(item.sell_in).to eq(0)
      end
    end

    context 'after sell date' do
      let(:sell_in) { -5 }
      let(:quality) { 80 }

      it 'does not change quality' do
        updater.update
        expect(item.quality).to eq(80)
      end

      it 'does not change sell_in' do
        updater.update
        expect(item.sell_in).to eq(-5)
      end
    end
  end
end
