# frozen_string_literal: true

require 'stringio'
require 'logger'

RSpec.describe Faraday::Response::Logger do
  let(:string_io) { StringIO.new }
  let(:logger) { Logger.new(string_io) }
  let(:conn) do
    rubbles = %w(Barney Betty)
    logger_options = {
      bodies: true,
      formatter: FinAppsCore::Logging::ContenTypeFormatter
    }

    Faraday.new do |b|
      b.response :logger, logger, logger_options
      b.adapter :test do |stubs|
        stubs.get('/text') { [200, {'Content-Type' => 'text/plain'}, 'hello'] }
        stubs.get('/json') { [200, {'Content-Type' => 'application/json'}, rubbles] }
        stubs.get('/pdf') { [200, {'Content-Type' => 'application/pdf'}, 'binary-here'] }
      end
    end
  end

  before do
    logger.level = Logger::DEBUG
  end

  context 'when content type is text/plain' do
    before { conn.get '/text' }

    it 'logs response body' do
      expect(string_io.string).to match('hello')
    end
  end

  context 'when content type is application/json' do
    before { conn.get '/json' }

    it 'logs response body' do
      expect(string_io.string).to match('[\"Barney\", \"Betty\"]')
    end
  end

  context 'when content type is something else' do
    before { conn.get '/pdf' }

    it 'does not log response body' do
      expect(string_io.string).not_to match('binary-here')
    end
  end
end
