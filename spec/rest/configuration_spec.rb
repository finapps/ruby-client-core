# frozen_string_literal: true

require 'finapps_core/error'

RSpec.describe FinAppsCore::REST::Configuration do
  describe '#new' do
    context 'for invalid timeout configuration' do
      subject { described_class.new(timeout: 'whatever') }

      expected_error = FinAppsCore::InvalidArgumentsError
      it { expect { subject }.to raise_error(expected_error, 'Invalid argument. {timeout: whatever}') }
    end

    context 'for missing timeout configuration' do
      subject { described_class.new(timeout: nil) }

      it 'has a default timeout value' do
        expect(subject.timeout).to eq(FinAppsCore::REST::Defaults::DEFAULTS[:timeout])
      end
    end

    context 'for invalid host configuration' do
      subject { described_class.new(host: 'whatever') }

      expected_error = FinAppsCore::InvalidArgumentsError
      it { expect { subject }.to raise_error(expected_error, 'Invalid argument. {host: whatever}') }
    end

    context 'for missing host configuration' do
      subject { described_class.new(host: nil) }

      it 'has a default host value' do
        expect(subject.host).to eq(FinAppsCore::REST::Defaults::DEFAULTS[:host])
      end
    end
  end

  describe '#valid_user_credentials??' do
    context 'when user credentials were not set' do
      subject { described_class.new(host: nil) }

      it { expect(subject.valid_user_credentials?).to eq(false) }
    end

    context 'when user credentials were set' do
      subject { described_class.new(user_identifier: 1, user_token: 2) }

      it { expect(subject.valid_user_credentials?).to eq(true) }
    end
  end
end
