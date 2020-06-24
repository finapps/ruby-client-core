# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::NoEncodingBasicAuthentication do
  let(:key) { FinAppsCore::Middleware::NoEncodingBasicAuthentication::KEY }

  describe '#call' do
    app = proc {|env| env }

    context 'when credentials were provided' do
      let(:middleware) { described_class.new(app, :token) }
      let(:expected_header_value) { 'Bearer token' }

      context 'when header was not previously set' do
        subject(:result) { middleware.call(request_env) }

        let(:request_env) { {request_headers: {}} }

        it('generates a header') {
          expect(result[:request_headers][key]).to eq(expected_header_value)
        }
      end

      context 'when header was previously set' do
        subject(:result) { middleware.call(request_env) }

        let(:request_env) { {request_headers: {key => 'foo'}} }

        it('does not override existing header') {
          expect(result[:request_headers][key]).to eq('foo')
        }

        it('does not generate a header') {
          expect(result[:request_headers][key]).not_to eq(expected_header_value)
        }
      end
    end
  end
end
