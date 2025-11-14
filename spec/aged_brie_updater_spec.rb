require 'rspec'
require 'lib/gilded_rose'
require 'lib/aged_brie_updater'

RSpec.describe AgedBrieUpdater do
  let(:item) { Item.new('Aged Brie', sell_in, quality) }
  let(:updater) { AgedBrieUpdater.new(item) }

  describe '#update' do
    context 'before sell date' do
      let(:sell_in) { 5 }
      let(:quality) { 10 }

      it 'increases quality by 1' do
        updater.update
        expect(item.quality).to eq(11)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(4)
      end
    end

    context 'on sell date' do
      let(:sell_in) { 0 }
      let(:quality) { 10 }

      it 'increases quality by 2' do
        updater.update
        expect(item.quality).to eq(12)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(-1)
      end
    end

    context 'after sell date' do
      let(:sell_in) { -5 }
      let(:quality) { 10 }

      it 'increases quality by 2' do
        updater.update
        expect(item.quality).to eq(12)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(-6)
      end
    end

    context 'with max quality' do
      let(:sell_in) { 5 }
      let(:quality) { 50 }

      it 'does not increase quality above 50' do
        updater.update
        expect(item.quality).to eq(50)
      end
    end

    context 'near max quality before sell date' do
      let(:sell_in) { 5 }
      let(:quality) { 49 }

      it 'caps quality at 50' do
        updater.update
        expect(item.quality).to eq(50)
      end
    end

    context 'near max quality after sell date' do
      let(:sell_in) { -1 }
      let(:quality) { 49 }

      it 'caps quality at 50' do
        updater.update
        expect(item.quality).to eq(50)
      end
    end
  end
end
