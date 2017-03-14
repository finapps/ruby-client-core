# frozen_string_literal: true
RSpec.describe ObjectExtensions do
  context 'when refining Object' do
    using ObjectExtensions

    describe '#blank?' do
      # An object is blank if it's false, empty, or a whitespace string.
      context 'for false' do
        it { expect(false.blank?).to eq(true) }
      end
      context 'for empty arrays' do
        it { expect([].blank?).to eq(true) }
      end
      context 'for empty hashes' do
        it { expect({}.blank?).to eq(true) }
      end
      context 'for whitespace string' do
        it { expect(''.blank?).to eq(true) }
      end
    end

    describe '#present?' do
      # An object is present if it's not blank.
      context 'for not blank objects' do
        it { expect(1.present?).to eq(true) }
      end

      context 'for blank objects' do
        it { expect(false.present?).to eq(false) }
      end
    end
  end
end
