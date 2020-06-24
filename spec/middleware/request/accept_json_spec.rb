# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::AcceptJson do
  let(:fake_app) { proc {|env| env } }

  describe '#call' do
    subject(:accept_json) { described_class.new(fake_app) }

    env = {request_headers: {}}

    it('generates a UserAgent header') do
      header_key = FinAppsCore::Middleware::AcceptJson::KEY
      expect(accept_json.call(env)[:request_headers][header_key])
        .to eq('application/json')
    end
  end
end
