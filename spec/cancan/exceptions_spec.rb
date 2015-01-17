require "spec_helper"

describe CanCan::Unauthorized do
  subject(:exception) { CanCan::Unauthorized.new(some_message, some_action, some_subject) }

  let(:default_message) { "You are not authorized to access this page." }
  let(:some_message) { nil }
  let(:some_action) { nil }
  let(:some_subject) { nil }

  shared_examples CanCan::Unauthorized do
    describe '#action' do
      it { expect(exception.action).to eq(some_action) }
    end

    describe '#subject' do
      it { expect(exception.subject).to eq(some_subject) }
    end

    describe '#message' do
      it { expect(exception.message).to eq(some_message.nil? ? default_message : some_message) }
    end
  end

  context 'with action, subject and no message' do
    let(:some_action) { :some_action }
    let(:some_subject) { :some_subject }

    it_behaves_like CanCan::Unauthorized

    context 'when default message changed' do
      let(:default_message) { 'Unauthorized!' }

      before do
        exception.default_message = default_message
      end

      it 'should be use changed default message' do
        expect(exception.message).to eq(default_message)
      end
    end

  end

  context 'with only a message' do
    let(:some_message) { "Access denied!" }

    it_behaves_like CanCan::Unauthorized
  end

  context 'when i18n in the default message' do
    let(:translation) { "This is a different message" }

    before do
      I18n.backend.store_translations :en, :unauthorized => {:default => translation }
    end

    after(:each) do
      I18n.backend = nil
    end

    it 'should use i18n translation' do
      expect(exception.message).to eq(translation)
    end

    context 'when has message' do
      let(:some_message) { "Hey! You're not welcome here" }

      it 'should use message' do
       expect(exception.message).to eq(some_message)
      end
    end

  end
end
