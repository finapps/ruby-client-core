# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::XConsumerId do
  let(:key) { FinAppsCore::Middleware::XConsumerId::KEY }
  let(:id) { 'valid_consumer_id' }
  let(:fake_app) { proc {|env| env } }
  let(:env) { {request_headers: {}} }

  describe '#call' do
    subject { described_class.new(fake_app, id) }

    it('generates an X-Consumer-ID header') do
      expect(subject.call(env)[:request_headers][key]).to eq(id)
    end
  end
end
