# frozen_string_literal: true

RSpec.describe FinAppsCore::REST::BaseClient do
  subject(:base_client) { described_class.new(valid_tenant_options) }

  let(:valid_tenant_options) { {tenant_token: VALID_CREDENTIALS[:token]} }

  before do
    stub_const 'RESPONSE', 0
    stub_const 'ERROR_MESSAGES', 1
  end

  describe '#new' do
    it 'assigns @config' do
      expect(base_client.config).to be_a(FinAppsCore::REST::Configuration)
    end
  end

  describe '#connection' do
    it 'created a Faraday connection object' do
      expect(base_client.connection).to be_a(Faraday::Connection)
    end

    it 'memoizes the results' do
      first = base_client.connection
      second = base_client.connection
      expect(first.object_id).to eq(second.object_id)
    end
  end

  describe '#send_request' do
    it 'raises NoMethodError if method is NOT supported' do
      expect { base_client.send_request('fake_path', :option) }
        .to(raise_error(NoMethodError, /undefined method `option/))
    end

    it 'raises FinAppsCore::MissingArgumentsError if method is NOT provided' do
      expect { base_client.send_request(nil, :get) }
        .to(raise_error(FinAppsCore::MissingArgumentsError, ': path'))
    end

    it 'raises FinAppsCore::MissingArgumentsError if path is NOT provided' do
      expect { base_client.send_request('fake_path', nil) }
        .to raise_error(FinAppsCore::MissingArgumentsError, ': method')
    end

    context 'when method and path are provided' do
      subject(:results) do
        described_class.new(valid_tenant_options)
                       .send_request('relevance/ruleset/names', :get)
      end

      it('returns an array') do
        expect(results).to be_a(Array)
      end

      it('returns an array of length=2') do
        expect(results.size).to eq(2)
      end

      context 'with client errors' do
        subject(:client_error) do
          described_class.new(valid_tenant_options)
                         .send_request('client_error', :get)
        end

        it('result is null') { expect(client_error[RESPONSE]).to be_nil }

        it('error_messages is an array') {
          expect(client_error[ERROR_MESSAGES]).to be_a(Array)
        }

        it('error_messages gets populated') {
          expect(client_error[ERROR_MESSAGES].first)
            .to eq 'Password Minimum size is 8'
        }
      end

      context 'with server errors' do
        subject(:server_error) do
          described_class.new(valid_tenant_options)
                         .send_request('server_error', :get)
        end

        it('the result should be nil') {
          expect(server_error[RESPONSE]).to be_nil
        }

        it('error messages should not be nil') {
          expect(server_error[ERROR_MESSAGES]).not_to be_nil
        }

        it('error messages should be an array') {
          expect(server_error[ERROR_MESSAGES]).to be_a(Array)
        }

        it('the first error message should match') {
          expect(server_error[ERROR_MESSAGES].first)
            .to eq 'the server responded with status 500'
        }
      end

      context 'with proxy errors' do
        subject(:proxy_error) do
          described_class.new(valid_tenant_options)
                         .send_request('proxy_error', :get)
        end

        it {
          expect { proxy_error }
            .to(raise_error(FinAppsCore::ConnectionFailedError,
                            'Connection Failed'))
        }
      end
    end

    context 'when a block is provided' do
      it('gets executed on the response and returned as the result') do
        expect(base_client
          .send_request('relevance/ruleset/names', :get) {|r| r.body.length })
          .to eq([45, []])
      end
    end
  end

  describe '#method_missing' do
    context 'with unsupported methods' do
      it { expect { base_client.unsupported }.to raise_error(NoMethodError) }
    end
  end

  describe '#respond_to_missing?' do
    context 'with supported methods' do
      %i[get post put delete].each do |method|
        it("responds to #{method}") {
          expect(base_client).to respond_to(method)
        }
      end
    end
  end
end
