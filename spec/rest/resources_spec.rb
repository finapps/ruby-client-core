# frozen_string_literal: true

RSpec.describe FinAppsCore::REST::Resources do
  describe '#new' do
    context 'with a valid client param' do
      subject(:resources) { described_class.new :client }

      it { expect { resources }.not_to raise_error }
    end

    context 'when missing client param' do
      subject(:resources) { described_class.new nil }

      it {
        expect { resources }
          .to raise_error(FinAppsCore::MissingArgumentsError)
      }
    end
  end
end
