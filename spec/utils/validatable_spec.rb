# frozen_string_literal: true

class FakeClass
  include FinAppsCore::Utils::Validatable
end

RSpec.describe FinAppsCore::Utils::Validatable do
  describe '#not_blank' do
    context 'for null values' do
      it 'should raise FinAppsCore::MissingArgumentsError' do
        expect { FakeClass.new.not_blank(nil) }.to raise_error(FinAppsCore::MissingArgumentsError,
                                                               'Missing argument')
      end

      it 'should describe the argument name when provided' do
        expect { FakeClass.new.not_blank(nil, :name) }.to raise_error(FinAppsCore::MissingArgumentsError,
                                                                      'Missing argument: name')
      end
    end

    context 'for non null values' do
      it 'should not raise' do
        expect { FakeClass.new.not_blank(true) }.not_to raise_error
      end
    end
  end
end
