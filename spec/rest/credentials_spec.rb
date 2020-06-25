# frozen_string_literal: true

RSpec.describe FinAppsCore::REST::Credentials do
  describe '#valid?' do
    context 'when missing identifier' do
      it { expect(described_class.new(nil, :token).valid?).to be(true) }
    end

    context 'when missing token' do
      it { expect(described_class.new(:identifier, nil).valid?).to be(false) }
    end

    context 'when missing both identifier and token' do
      it { expect(described_class.new(nil, nil).valid?).to be(false) }
    end

    context 'when having identifier and token' do
      it { expect(described_class.new(:identifier, :token).valid?).to be(true) }
    end
  end
end
