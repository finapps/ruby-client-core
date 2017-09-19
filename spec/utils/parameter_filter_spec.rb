# frozen_string_literal: true

class FakeClass
  include FinAppsCore::Utils::ParameterFilter
end

RSpec.describe FinAppsCore::Utils::ParameterFilter do
  describe '#skip_sensitive_data' do
    context 'when provided with sensitive data' do
      let(:unfiltered_params) do
        {
          password: 'FinApps@123',
          password_confirm: 'FinApps@123',
          token: '123456',
          login: 'sammysosa',
          username: 'johnny',
          name: 'george',
          routing_no: '2316151651',
          account_no: '987984654',
          tpr_id: 'asdfasdf5465w1e65r4we654r',
          'x-tenant-token': '498798465132154987498'
        }
      end
      let(:filtered_params) do
        {
          password: '[REDACTED]',
          password_confirm: '[REDACTED]',
          token: '[REDACTED]',
          login: '[REDACTED]',
          username: '[REDACTED]',
          name: 'george',
          routing_no: '[REDACTED]',
          account_no: '[REDACTED]',
          tpr_id: '[REDACTED]',
          'x-tenant-token': '[REDACTED]'
        }
      end

      it 'filters out sensitive values' do
        expect(FakeClass.new.skip_sensitive_data(unfiltered_params)).to eq(filtered_params)
      end
    end
  end
end
