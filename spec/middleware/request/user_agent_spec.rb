# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::UserAgent do
  let(:fake_app) { proc {|env| env } }

  describe '#call' do
    subject(:user_agent) { described_class.new(fake_app) }

    let(:key) { FinAppsCore::Middleware::UserAgent::KEY }

    env = {request_headers: {}}

    it('generates a UserAgent header') do
      expect(user_agent.call(env)[:request_headers][key])
        .to start_with('finapps-ruby')
    end
  end
end
