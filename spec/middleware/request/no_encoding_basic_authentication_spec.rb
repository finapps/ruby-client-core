# frozen_string_literal: true
RSpec.describe FinAppsCore::Middleware::NoEncodingBasicAuthentication do
  let(:key) { FinAppsCore::Middleware::NoEncodingBasicAuthentication::KEY }

  describe '#call' do
    app = proc {|env| env }

    context 'when credentials were provided' do
      let(:middleware) { FinAppsCore::Middleware::NoEncodingBasicAuthentication.new(app, VALID_CREDENTIALS[:token]) }
      let(:expected_header_value) { "Basic #{VALID_CREDENTIALS[:token]}" }

      context 'when header was not previously set' do
        let(:request_env) { {request_headers: {}} }
        subject(:result) { middleware.call(request_env) }

        it('generates a header') { expect(result[:request_headers][key]).to eq(expected_header_value) }
      end

      context 'when header was previously set' do
        let(:request_env) { {request_headers: {key => 'foo'}} }
        subject(:result) { middleware.call(request_env) }

        it('does not override existing header') { expect(result[:request_headers][key]).to eq('foo') }
        it('does not generate a header') { expect(result[:request_headers][key]).to_not eq(expected_header_value) }
      end
    end
  end
end
