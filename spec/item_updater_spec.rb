require 'rspec'
require 'lib/gilded_rose'
require 'lib/item_updater'

RSpec.describe ItemUpdater do
  # Concrete implementation for testing the base class
  class TestUpdater < ItemUpdater
    def update
      decrease_quality
      decrease_sell_in
    end
  end

  let(:item) { Item.new('Test Item', 10, 20) }
  let(:updater) { TestUpdater.new(item) }

  describe '#constrain_quality' do
    context 'when quality exceeds maximum' do
      it 'caps quality at 50' do
        item.quality = 60
        updater.send(:constrain_quality)
        expect(item.quality).to eq(50)
      end
    end

    context 'when quality goes below minimum' do
      it 'floors quality at 0' do
        item.quality = -10
        updater.send(:constrain_quality)
        expect(item.quality).to eq(0)
      end
    end

    context 'when quality is within bounds' do
      it 'does not change quality' do
        item.quality = 25
        updater.send(:constrain_quality)
        expect(item.quality).to eq(25)
      end
    end
  end

  describe '#decrease_quality' do
    it 'decreases quality by 1 by default' do
      updater.send(:decrease_quality)
      expect(item.quality).to eq(19)
    end

    it 'decreases quality by specified amount' do
      updater.send(:decrease_quality, 5)
      expect(item.quality).to eq(15)
    end

    it 'does not go below 0' do
      item.quality = 2
      updater.send(:decrease_quality, 5)
      expect(item.quality).to eq(0)
    end
  end

  describe '#increase_quality' do
    it 'increases quality by 1 by default' do
      updater.send(:increase_quality)
      expect(item.quality).to eq(21)
    end

    it 'increases quality by specified amount' do
      updater.send(:increase_quality, 5)
      expect(item.quality).to eq(25)
    end

    it 'does not go above 50' do
      item.quality = 48
      updater.send(:increase_quality, 5)
      expect(item.quality).to eq(50)
    end
  end

  describe '#decrease_sell_in' do
    it 'decreases sell_in by 1' do
      updater.send(:decrease_sell_in)
      expect(item.sell_in).to eq(9)
    end
  end

  describe '#past_sell_date?' do
    it 'returns false when sell_in is positive' do
      item.sell_in = 5
      expect(updater.send(:past_sell_date?)).to be false
    end

    it 'returns false when sell_in is 0' do
      item.sell_in = 0
      expect(updater.send(:past_sell_date?)).to be false
    end

    it 'returns true when sell_in is negative' do
      item.sell_in = -1
      expect(updater.send(:past_sell_date?)).to be true
    end
  end
end
