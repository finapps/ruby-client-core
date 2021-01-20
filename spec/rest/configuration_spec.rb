# frozen_string_literal: true

require 'finapps_core/error'

RSpec.describe FinAppsCore::REST::Configuration do
  describe '#new' do
    expected_error = FinAppsCore::InvalidArgumentsError
    default_host = FinAppsCore::REST::Defaults::DEFAULTS[:host]

    context 'with invalid timeout configuration' do
      subject(:configuration) { described_class.new(timeout: 'foo') }

      it {
        expect { configuration }
          .to raise_error(expected_error, 'Invalid argument. {timeout: foo}')
      }
    end

    context 'with missing timeout configuration' do
      default_timeout = FinAppsCore::REST::Defaults::DEFAULTS[:timeout]
      subject(:configuration) { described_class.new(timeout: nil) }

      it 'has a default timeout value' do
        expect(configuration.timeout).to eq(default_timeout)
      end
    end

    context 'with invalid host configuration' do
      subject(:configuration) { described_class.new(host: 'foo') }

      it do
        expect { configuration }
          .to raise_error(expected_error, 'Invalid argument. {host: foo}')
      end
    end

    context 'with valid host configuration' do
      subject(:configuration) { described_class.new(host: 'https://api.com/') }

      it 'the default host value is not used' do
        expect(configuration.host).not_to eq(default_host)
      end

      it 'the provided host value is assigned to host' do
        expect(configuration.host).to include('https://api.com')
      end

      context 'when given host value ends on /' do
        it 'the / character is removed' do
          expect(configuration.host).not_to end_with('/')
        end
      end
    end

    context 'with missing host configuration' do
      subject(:configuration) { described_class.new(host: nil) }

      it 'has a default host value' do
        expect(configuration.host).to eq(default_host)
      end
    end
  end

  describe '#valid_user_credentials??' do
    context 'when user credentials were not set' do
      subject(:configuration) { described_class.new(host: nil) }

      it { expect(configuration.valid_user_credentials?).to eq(false) }
    end

    context 'when user credentials were set' do
      subject(:configuration) do
        described_class.new(user_identifier: 1, user_token: 2)
      end

      it { expect(configuration.valid_user_credentials?).to eq(true) }
    end
  end
end
