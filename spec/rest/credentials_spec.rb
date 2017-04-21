# frozen_string_literal: true
RSpec.describe FinAppsCore::REST::Credentials do
  describe '#valid?' do
    context 'when missing identifier' do
      it { expect(FinAppsCore::REST::Credentials.new(nil, :token).valid?).to eql(true) }
    end

    context 'when missing token' do
      it { expect(FinAppsCore::REST::Credentials.new(:identifier, nil).valid?).to eql(false) }
    end

    context 'when missing both identifier and token' do
      it { expect(FinAppsCore::REST::Credentials.new(nil, nil).valid?).to eql(false) }
    end

    context 'when having identifier and token' do
      it { expect(FinAppsCore::REST::Credentials.new(:identifier, :token).valid?).to eql(true) }
    end
  end
end
