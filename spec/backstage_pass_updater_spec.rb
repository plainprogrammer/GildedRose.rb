require 'rspec'
require 'lib/gilded_rose'
require 'lib/backstage_pass_updater'

RSpec.describe BackstagePassUpdater do
  let(:item) { Item.new('Backstage passes to a TAFKAL80ETC concert', sell_in, quality) }
  let(:updater) { BackstagePassUpdater.new(item) }

  describe '#update' do
    context 'long before concert' do
      let(:sell_in) { 11 }
      let(:quality) { 10 }

      it 'increases quality by 1' do
        updater.update
        expect(item.quality).to eq(11)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(10)
      end
    end

    context 'medium close to concert (upper bound, 10 days)' do
      let(:sell_in) { 10 }
      let(:quality) { 10 }

      it 'increases quality by 2' do
        updater.update
        expect(item.quality).to eq(12)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(9)
      end
    end

    context 'medium close to concert (lower bound, 6 days)' do
      let(:sell_in) { 6 }
      let(:quality) { 10 }

      it 'increases quality by 2' do
        updater.update
        expect(item.quality).to eq(12)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(5)
      end
    end

    context 'very close to concert (upper bound, 5 days)' do
      let(:sell_in) { 5 }
      let(:quality) { 10 }

      it 'increases quality by 3' do
        updater.update
        expect(item.quality).to eq(13)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(4)
      end
    end

    context 'very close to concert (lower bound, 1 day)' do
      let(:sell_in) { 1 }
      let(:quality) { 10 }

      it 'increases quality by 3' do
        updater.update
        expect(item.quality).to eq(13)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(0)
      end
    end

    context 'on concert day' do
      let(:sell_in) { 0 }
      let(:quality) { 10 }

      it 'drops quality to 0' do
        updater.update
        expect(item.quality).to eq(0)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(-1)
      end
    end

    context 'after concert' do
      let(:sell_in) { -5 }
      let(:quality) { 10 }

      it 'drops quality to 0' do
        updater.update
        expect(item.quality).to eq(0)
      end

      it 'decreases sell_in by 1' do
        updater.update
        expect(item.sell_in).to eq(-6)
      end
    end

    context 'at max quality long before concert' do
      let(:sell_in) { 11 }
      let(:quality) { 50 }

      it 'does not increase quality above 50' do
        updater.update
        expect(item.quality).to eq(50)
      end
    end

    context 'at max quality medium close to concert' do
      let(:sell_in) { 10 }
      let(:quality) { 50 }

      it 'does not increase quality above 50' do
        updater.update
        expect(item.quality).to eq(50)
      end
    end

    context 'at max quality very close to concert' do
      let(:sell_in) { 5 }
      let(:quality) { 50 }

      it 'does not increase quality above 50' do
        updater.update
        expect(item.quality).to eq(50)
      end
    end
  end
end
