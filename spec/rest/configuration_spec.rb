# frozen_string_literal: true

require 'finapps_core/error'

RSpec.describe FinAppsCore::REST::Configuration do
  describe '#new' do
    context 'with invalid timeout configuration' do
      subject(:configuration) { described_class.new(timeout: 'whatever') }

      expected_error = FinAppsCore::InvalidArgumentsError
      it { expect { configuration }.to raise_error(expected_error, 'Invalid argument. {timeout: whatever}') }
    end

    context 'with missing timeout configuration' do
      subject(:configuration) { described_class.new(timeout: nil) }

      it 'has a default timeout value' do
        expect(configuration.timeout).to eq(FinAppsCore::REST::Defaults::DEFAULTS[:timeout])
      end
    end

    context 'with invalid host configuration' do
      subject(:configuration) { described_class.new(host: 'whatever') }

      expected_error = FinAppsCore::InvalidArgumentsError
      it { expect { configuration }.to raise_error(expected_error, 'Invalid argument. {host: whatever}') }
    end

    context 'with missing host configuration' do
      subject(:configuration) { described_class.new(host: nil) }

      it 'has a default host value' do
        expect(configuration.host).to eq(FinAppsCore::REST::Defaults::DEFAULTS[:host])
      end
    end
  end

  describe '#valid_user_credentials??' do
    context 'when user credentials were not set' do
      subject(:configuration) { described_class.new(host: nil) }

      it { expect(configuration.valid_user_credentials?).to eq(false) }
    end

    context 'when user credentials were set' do
      subject(:configuration) { described_class.new(user_identifier: 1, user_token: 2) }

      it { expect(configuration.valid_user_credentials?).to eq(true) }
    end
  end
end
