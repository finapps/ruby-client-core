# frozen_string_literal: true

RSpec.describe FinAppsCore::REST::Defaults do
  let(:fake_class) { Class.new }

  describe 'set constants' do
    before { stub_const(described_class.to_s, fake_class) }

    it('sets API_VERSION') { expect(described_class::API_VERSION).to eq '2' }
    it('sets DEFAULTS') { expect(described_class::DEFAULTS).to be_a(Hash) }
    it('freezes DEFAULTS') { expect(described_class::DEFAULTS).to be_frozen }
    it('sets DEFAULTS[:host]') { expect(described_class::DEFAULTS[:host]).to eq 'https://api.financialapps.com' }
    it('sets DEFAULTS[:timeout]') { expect(described_class::DEFAULTS[:timeout]).to eq 30 }
    it('does not set DEFAULTS[:proxy]') { expect(described_class::DEFAULTS[:proxy]).to be_nil }
    it('sets DEFAULTS[:retry_limit]') { expect(described_class::DEFAULTS[:retry_limit]).to eq 1 }
    it('sets DEFAULTS[:log_level]') { expect(described_class::DEFAULTS[:log_level]).to eq Logger::INFO }
  end
end
