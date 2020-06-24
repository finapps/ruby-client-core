# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::TenantAuthentication do
  describe '#call' do
    subject(:actual_header) do
      middleware.call(request_env)[:request_headers][key]
    end

    context 'when company credentials were provided' do
      let(:key) { FinAppsCore::Middleware::TenantAuthentication::KEY }
      let(:middleware) do
        fake_app = proc {|env| env }
        described_class.new(fake_app, VALID_CREDENTIALS[:token])
      end
      let(:expected_header) { VALID_CREDENTIALS[:token] }

      context 'when header was not previously set' do
        let(:request_env) { {request_headers: {}} }

        it('generates a Tenant Authentication header') {
          expect(actual_header).to eq(expected_header)
        }
      end

      context 'when header was previously set' do
        let(:request_env) { {request_headers: {key => 'foo'}} }

        it('does not override existing Tenant Authentication header') {
          expect(actual_header).to eq('foo')
        }

        it('does not generate a Tenant Authentication header') {
          expect(actual_header).not_to eq(expected_header)
        }
      end
    end
  end
end
