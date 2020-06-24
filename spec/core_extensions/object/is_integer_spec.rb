# frozen_string_literal: true

RSpec.describe ObjectExtensions do
  context 'when refining Object' do
    using described_class

    describe '#integer?' do
      context 'with integers' do
        it { expect(rand(1..10).integer?).to eq(true) }
      end

      context 'with non integers' do
        it { expect(rand.integer?).to eq(false) }
      end
    end
  end
end
