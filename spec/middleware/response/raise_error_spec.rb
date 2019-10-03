# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::RaiseError do
  let(:fake_app) { proc {|env| env } }
  Env = Struct.new(:status, :response_headers, :body)

  describe '#on_complete' do
    subject { FinAppsCore::Middleware::RaiseError.new(fake_app) }

    context 'for successful requests' do
      let(:env) { Env.new(200) }
      it { expect { subject.on_complete(env) }.not_to raise_error }
    end
    context 'for invalid session errors' do
      let(:env) { Env.new(401, {}, '{"messages":["Invalid User Identifier or Credentials"]}') }
      error_message = 'API Invalid Session'
      it { expect { subject.on_complete(env) }.to raise_error(FinAppsCore::ApiUnauthenticatedError, error_message) }
    end
    context 'for client errors' do
      let(:env) { Env.new(404, {}, '{"messages":["Resource Not Found"]}') }
      error_message = 'the server responded with status 404'
      it { expect { subject.on_complete(env) }.to raise_error(Faraday::ClientError, error_message) }
    end
    context 'for connection failed error' do
      let(:env) { Env.new(407) }
      error_message = 'Connection Failed'
      it { expect { subject.on_complete(env) }.to raise_error(FinAppsCore::ConnectionFailedError, error_message) }
    end
    context 'for session timeout error' do
      let(:env) { Env.new(419) }
      error_message = 'API Session Timed out'
      it { expect { subject.on_complete(env) }.to raise_error(FinAppsCore::ApiSessionTimeoutError, error_message) }
    end
    context 'for user lockout error' do
      let(:env) { Env.new(403, {}, '{"messages":["Account is locked"]}') }
      error_message = 'User is Locked'
      it { expect { subject.on_complete(env) }.to raise_error(FinAppsCore::UserLockoutError, error_message) }
    end
  end
end
