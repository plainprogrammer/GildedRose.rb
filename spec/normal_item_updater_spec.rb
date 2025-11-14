require 'rspec'
require 'lib/gilded_rose'
require 'lib/normal_item_updater'

RSpec.describe NormalItemUpdater do
  let(:item) { Item.new('Normal Item', sell_in, quality) }
  let(:updater) { NormalItemUpdater.new(item) }

  describe '#update' do
    context 'before sell date' do
      let(:sell_in) { 5 }
      let(:quality) { 10 }

      it 'decreases quality by 1' do
        updater.update
        expect(item.quality).to eq(9)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(4)
      end
    end

    context 'on sell date' do
      let(:sell_in) { 0 }
      let(:quality) { 10 }

      it 'decreases quality by 2' do
        updater.update
        expect(item.quality).to eq(8)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(-1)
      end
    end

    context 'after sell date' do
      let(:sell_in) { -5 }
      let(:quality) { 10 }

      it 'decreases quality by 2' do
        updater.update
        expect(item.quality).to eq(8)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(-6)
      end
    end

    context 'with zero quality' do
      let(:sell_in) { 5 }
      let(:quality) { 0 }

      it 'does not decrease quality below 0' do
        updater.update
        expect(item.quality).to eq(0)
      end
    end

    context 'with quality 1 after sell date' do
      let(:sell_in) { -1 }
      let(:quality) { 1 }

      it 'does not decrease quality below 0' do
        updater.update
        expect(item.quality).to eq(0)
      end
    end
  end
end
