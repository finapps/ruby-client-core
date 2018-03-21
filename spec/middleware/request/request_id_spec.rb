# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::RequestId do
  let(:key) { FinAppsCore::Middleware::RequestId::KEY }
  let(:id) { 'request_id' }
  let(:fake_app) { proc {|env| env } }
  let(:env) { {request_headers: {}} }

  describe '#call' do
    subject { FinAppsCore::Middleware::RequestId.new(fake_app, id) }

    it('generates a X-Request-Id header') do
      expect(subject.call(env)[:request_headers][key]).to eq(id)
    end
  end
end
