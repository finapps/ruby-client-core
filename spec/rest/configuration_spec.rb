# frozen_string_literal: true

require 'finapps_core/error'

RSpec.describe FinAppsCore::REST::Configuration do
  describe '#new' do
    context 'for invalid timeout configuration' do
      subject { FinAppsCore::REST::Configuration.new(timeout: 'whatever') }
      expected_error = FinAppsCore::InvalidArgumentsError
      it { expect { subject }.to raise_error(expected_error, 'Invalid argument. {timeout: whatever}') }
    end

    context 'for missing timeout configuration' do
      subject { FinAppsCore::REST::Configuration.new(timeout: nil) }
      it 'should have a default timeout value' do
        expect(subject.timeout).to eq(FinAppsCore::REST::Defaults::DEFAULTS[:timeout])
      end
    end

    context 'for invalid host configuration' do
      subject { FinAppsCore::REST::Configuration.new(host: 'whatever') }
      expected_error = FinAppsCore::InvalidArgumentsError
      it { expect { subject }.to raise_error(expected_error, 'Invalid argument. {host: whatever}') }
    end

    context 'for missing host configuration' do
      subject { FinAppsCore::REST::Configuration.new(host: nil) }
      it 'should have a default host value' do
        expect(subject.host).to eq(FinAppsCore::REST::Defaults::DEFAULTS[:host])
      end
    end
  end

  describe '#valid_user_credentials??' do
    context 'when user credentials were not set' do
      subject { FinAppsCore::REST::Configuration.new(host: nil) }
      it { expect(subject.valid_user_credentials?).to eq(false) }
    end
    context 'when user credentials were set' do
      subject { FinAppsCore::REST::Configuration.new(user_identifier: 1, user_token: 2) }
      it { expect(subject.valid_user_credentials?).to eq(true) }
    end
  end
end
