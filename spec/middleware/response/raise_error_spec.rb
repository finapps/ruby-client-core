# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::RaiseError do
  let(:fake_app) { proc {|env| env } }

  before do
    stub_const('Env', Struct.new(:status, :response_headers, :body))
  end

  describe '#on_complete' do
    subject(:error_raiser) { described_class.new(fake_app) }

    context 'with successful requests' do
      let(:env) { Env.new(200) }

      it { expect { error_raiser.on_complete(env) }.not_to raise_error }
    end

    context 'with invalid session errors' do
      let(:env) do
        body = '{"messages":["Invalid User Identifier or Credentials"]}'
        Env.new(401, {}, body)
      end

      error_message = 'API Invalid Session'
      it {
        expect { error_raiser.on_complete(env) }
          .to raise_error(FinAppsCore::ApiUnauthenticatedError, error_message)
      }
    end

    context 'with client errors' do
      let(:env) { Env.new(404, {}, '{"messages":["Resource Not Found"]}') }

      error_message = 'the server responded with status 404'
      it {
        expect { error_raiser.on_complete(env) }
          .to raise_error(Faraday::ClientError, error_message)
      }
    end

    context 'with connection failed error' do
      let(:env) { Env.new(407) }

      error_message = 'Connection Failed'
      it {
        expect { error_raiser.on_complete(env) }
          .to raise_error(FinAppsCore::ConnectionFailedError, error_message)
      }
    end

    context 'with session timeout error' do
      let(:env) { Env.new(419) }

      error_message = 'API Session Timed out'
      it {
        expect { error_raiser.on_complete(env) }
          .to raise_error(FinAppsCore::ApiSessionTimeoutError, error_message)
      }
    end

    context 'with user lockout error' do
      let(:env) { Env.new(403, {}, '{"messages":["Account is locked"]}') }

      error_message = 'User is Locked'
      it {
        expect { error_raiser.on_complete(env) }
          .to raise_error(FinAppsCore::UserLockoutError, error_message)
      }
    end
  end
end
