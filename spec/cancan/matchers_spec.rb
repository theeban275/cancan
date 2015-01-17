require "spec_helper"

describe '#be_able_to' do
  subject(:object) { spy('object', can?: can_value) }

  let(:ability) { :read }
  let(:first_arg) { 123 }
  let(:args) { [first_arg] }
  let(:can_value) { true }

  describe 'delegates to can?' do
    before do
      expect(object).to be_able_to(ability, *args)
    end

    context 'when called with single arg' do
      it { expect(object).to have_received(:can?).with(ability, *args) }
    end

    context 'when called with multiple args' do
      let(:second_arg) { 456 }
      let(:args) { [first_arg, second_arg] }
      it { expect(object).to have_received(:can?).with(ability, *args) }
    end

  end

  describe 'fails' do

    context 'when can? expected on object that cannot' do
      let(:can_value) { false }
      it 'should report nice error' do
        expect{ expect(object).to be_able_to(ability, *args) }.to raise_error("expected to be able to :#{ability} #{first_arg}")
      end
    end

    context 'when can? not expected on object that can' do
      it 'should report nice error' do
        expect{ expect(object).not_to be_able_to(ability, *args) }.to raise_error("expected not to be able to :#{ability} #{first_arg}")
      end
    end

  end

end
