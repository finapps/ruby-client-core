# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::XConsumerId do
  let(:id) { 'valid_consumer_id' }
  let(:fake_app) { proc {|env| env } }
  let(:env) { {request_headers: {}} }

  describe '#call' do
    subject(:x_consumer_id) { described_class.new(fake_app, id) }

    it('generates an X-Consumer-ID header') do
      key = FinAppsCore::Middleware::XConsumerId::KEY
      expect(x_consumer_id.call(env)[:request_headers][key]).to eq(id)
    end
  end
end
