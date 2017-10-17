# frozen_string_literal: true

require 'spec_helpers/client'

RSpec.describe FinAppsCore::REST::Resources do
  include SpecHelpers::Client
  subject { FinAppsCore::REST::Resources.new client }

  describe '#new' do
    context 'for a valid client param' do
      it { expect { subject }.not_to raise_error }
    end

    context 'when missing client param' do
      subject { FinAppsCore::REST::Resources.new nil }
      it { expect { subject }.to raise_error(FinAppsCore::MissingArgumentsError) }
    end
  end

  describe '#list' do
  end
  describe '#create' do
  end
  describe '#update' do
  end
  describe '#show' do
  end
  describe '#destroy' do
  end
end
