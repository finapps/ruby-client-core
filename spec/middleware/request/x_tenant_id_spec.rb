# frozen_string_literal: true

RSpec.describe FinAppsCore::Middleware::XTenantId do
  let(:id) { 'valid_tenant_id' }
  let(:fake_app) { proc {|env| env } }
  let(:env) { {request_headers: {}} }

  describe '#call' do
    subject(:x_tenant_id) { described_class.new(fake_app, id) }

    it('generates an X-Tenant-ID header') do
      key = FinAppsCore::Middleware::XTenantId::KEY
      expect(x_tenant_id.call(env)[:request_headers][key]).to eq(id)
    end
  end
end
