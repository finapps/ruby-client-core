# frozen_string_literal: true
RSpec.describe FinAppsCore::REST::Resources do
  describe 'timeout' do
    subject { FinAppsCore::REST::Resources.new(FinAppsCore::REST::BaseClient.new({})).show(:timeout) }
    it { expect { subject }.to raise_error(FinAppsCore::ApiSessionTimeoutError) }
  end
end
