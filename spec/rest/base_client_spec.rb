# frozen_string_literal: true

RSpec.describe FinAppsCore::REST::BaseClient do
  let(:valid_tenant_options) { { tenant_token: VALID_CREDENTIALS[:token] } }
  subject { FinAppsCore::REST::BaseClient.new(valid_tenant_options) }

  RESPONSE = 0
  ERROR_MESSAGES = 1
  let(:return_array) { %i[RESPONSE ERROR_MESSAGES] }

  describe '#new' do
    it 'assigns @config' do
      expect(subject.config).to be_a(FinAppsCore::REST::Configuration)
    end
  end

  describe '#connection' do
    it 'created a Faraday connection object' do
      expect(subject.connection).to be_a(Faraday::Connection)
    end

    it 'memoizes the results' do
      first = subject.connection
      second = subject.connection
      expect(first.object_id).to eq(second.object_id)
    end
  end

  describe '#send_request' do
    it 'should raise FinAppsCore::InvalidArgumentsError if method is NOT supported' do
      expect { subject.send_request('fake_path', :option) }.to raise_error(FinAppsCore::UnsupportedHttpMethodError,
                                                                           'Method not supported: option.')
    end

    it 'should raise FinAppsCore::MissingArgumentsError if method is NOT provided' do
      expect { subject.send_request(nil, :get) }.to raise_error(FinAppsCore::MissingArgumentsError,
                                                                'Missing argument: path')
    end

    it 'should raise FinAppsCore::MissingArgumentsError if path is NOT provided' do
      expect { subject.send_request('fake_path', nil) }.to raise_error(FinAppsCore::MissingArgumentsError,
                                                                       'Missing argument: method')
    end

    context 'when method and path are provided' do
      subject { FinAppsCore::REST::BaseClient.new(valid_tenant_options).send_request('relevance/ruleset/names', :get) }
      let(:return_array) { %i[RESPONSE ERROR_MESSAGES] }

      it('returns an array of 2 items') do
        expect(subject).to be_a(Array)
        expect(subject.size).to eq(return_array.length)
      end

      context 'for client errors' do
        subject { FinAppsCore::REST::BaseClient.new(valid_tenant_options).send_request('client_error', :get) }

        it('result is null') { expect(subject[RESPONSE]).to be_nil }
        it('error_messages is an array') { expect(subject[ERROR_MESSAGES]).to be_a(Array) }
        it('error_messages gets populated') { expect(subject[ERROR_MESSAGES].first).to eq 'Password Minimum size is 8' }
      end

      context 'for server errors' do
        subject { FinAppsCore::REST::BaseClient.new(valid_tenant_options).send_request('server_error', :get) }

        it('the result should be nil') { expect(subject[RESPONSE]).to be_nil }
        it { expect(subject[ERROR_MESSAGES]).not_to be_nil }
        it { expect(subject[ERROR_MESSAGES]).to be_a(Array) }
        it { expect(subject[ERROR_MESSAGES].first).to eq 'the server responded with status 500' }
      end

      context 'for proxy errors' do
        subject { FinAppsCore::REST::BaseClient.new(valid_tenant_options).send_request('proxy_error', :get) }
        it { expect { subject }.to raise_error(FinAppsCore::ConnectionFailedError, 'Connection Failed') }
      end
    end

    context 'if a block is provided' do
      it('gets executed on the response and returned as the result') do
        expect(subject.send_request('relevance/ruleset/names', :get) {|r| r.body.length }).to eq([45, []])
      end
    end
  end

  describe '#method_missing' do
    context 'for unsupported methods' do
      it { expect { subject.unsupported }.to raise_error(NoMethodError) }
    end
  end

  describe '#respond_to_missing?' do
    context 'for supported methods' do
      %i[get post put delete].each do |method|
        it("responds to #{method}") { expect(subject).to respond_to(method) }
      end
    end
  end
end
