require "spec_helper"
require "ostruct" # for OpenStruct below

# Most of Rule functionality is tested in Ability specs
describe CanCan::Rule do
  subject(:rule) { CanCan::Rule.new(base_behavior, action, rsubject, conditions) }

  let(:base_behavior) { true }
  let(:action) { :read }
  let(:rsubject) { :integers }
  let(:conditions) { {} }

  describe '#associations_hash' do

    context 'when association joins is empty' do
      it { expect(rule.associations_hash).to be_empty }
    end

    context 'when association joins is nil' do
      let(:conditions) { nil }
      it { expect(rule.associations_hash).to be_empty }
    end

    context 'when association joins contains just attributes' do
      let(:conditions) { {foo: :bar} }
      it { expect(rule.associations_hash).to be_empty }
    end

    context 'when association joins contains a single association' do
      let(:conditions) { {foo: {bar: 1}} }
      it { expect(rule.associations_hash).to eq({foo: {}}) }
    end

    context 'when association joins contains multiple associations' do
      let(:conditions) { {foo: {bar: 1}, test: {1 => 2}} }
      it { expect(rule.associations_hash).to eq({foo: {}, test: {}}) }
    end

    context 'when association joins contains nested associations' do
      let(:conditions) { {foo: {bar: {1 => 2}}} }
      it { expect(rule.associations_hash).to eq({foo: {bar: {}}}) }
    end

  end

  describe '#specificity' do

    shared_examples 'specificity' do

      it { expect(rule.specificity).to eq(specificity_value) }

      describe 'should have higher specificity' do

        context 'when associations exist' do
          let(:conditions) { {foo: :bar} }
          it { expect(rule.specificity).to eq(higher_specificity_value) }
        end

        context 'when attributes exist' do
          let(:conditions) { :foo }
          it { expect(rule.specificity).to eq(higher_specificity_value) }
        end

      end

    end

    context 'when base behaviour is true' do
      let(:specificity_value) { 1 }
      let(:higher_specificity_value) { 2 }
      it_behaves_like 'specificity'
    end

    context 'when base behaviour is false' do
      let(:base_behavior) { false }
      let(:specificity_value) { 3 }
      let(:higher_specificity_value) { 4 }
      it_behaves_like 'specificity'
    end

  end

  context 'when conditions are not simple hashes' do
    let(:meta_where) { OpenStruct.new(:name => 'metawhere', :column => 'test') }
    let(:conditions) { {meta_where => :bar} }
    it { expect(rule).to be_unmergeable }
  end
end
