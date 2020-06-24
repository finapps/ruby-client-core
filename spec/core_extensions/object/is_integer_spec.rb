# frozen_string_literal: true

RSpec.describe ObjectExtensions do
  context 'when refining Object' do
    using described_class

    describe '#integer?' do
      context 'for integers' do
        subject { rand(1..10) }

        it { expect(subject.integer?).to eq(true) }
      end

      context 'for non integers' do
        subject { rand }

        it { expect(subject.integer?).to eq(false) }
      end
    end
  end
end
