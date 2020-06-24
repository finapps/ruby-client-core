# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::RequestId do
  let(:id) { 'request_id' }
  let(:fake_app) { proc {|env| env } }
  let(:env) { {request_headers: {}} }

  describe '#call' do
    subject(:request_id) { described_class.new(fake_app, id) }

    it('generates a X-Request-Id header') do
      key = FinAppsCore::Middleware::RequestId::KEY
      expect(request_id.call(env)[:request_headers][key]).to eq(id)
    end
  end
end
