# frozen_string_literal: true

class FakeClass
  include FinAppsCore::Utils::Validatable
end

RSpec.describe FinAppsCore::Utils::Validatable do
  describe '#not_blank' do
    context 'with null values' do
      it 'raises FinAppsCore::MissingArgumentsError' do
        expect { FakeClass.new.not_blank(nil) }
          .to raise_error(FinAppsCore::MissingArgumentsError)
      end

      it 'describes the argument name when provided' do
        expect { FakeClass.new.not_blank(nil, :name) }
          .to raise_error(FinAppsCore::MissingArgumentsError, ': name')
      end
    end

    context 'with non null values' do
      it 'does not raise' do
        expect { FakeClass.new.not_blank(true) }.not_to raise_error
      end
    end
  end
end
