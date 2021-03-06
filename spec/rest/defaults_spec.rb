# frozen_string_literal: true

RSpec.describe FinAppsCore::REST::Defaults do
  let(:fake_class) { Class.new }

  describe 'set constants' do
    before { stub_const(described_class.to_s, fake_class) }

    it('sets API_VERSION') { expect(described_class::API_VERSION).to eq '5' }
    it('sets DEFAULTS') { expect(described_class::DEFAULTS).to be_a(Hash) }
    it('freezes DEFAULTS') { expect(described_class::DEFAULTS).to be_frozen }

    it('sets DEFAULTS[:host]') {
      expected = 'https://api.allcleardecisioning.com'
      expect(described_class::DEFAULTS[:host]).to eq expected
    }

    it('sets DEFAULTS[:timeout]') {
      expect(described_class::DEFAULTS[:timeout]).to eq 30
    }

    it('does not set DEFAULTS[:proxy]') {
      expect(described_class::DEFAULTS[:proxy]).to be_nil
    }

    it('sets DEFAULTS[:log_level]') {
      expect(described_class::DEFAULTS[:log_level]).to eq Logger::UNKNOWN
    }
  end
end
