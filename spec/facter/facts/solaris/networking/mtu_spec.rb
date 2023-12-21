# frozen_string_literal: true

describe Facts::Solaris::Networking::Mtu do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Solaris::Networking::Mtu.new }

    let(:value) { 1500 }

    before do
      allow(Facter::Resolvers::Solaris::Networking).to receive(:resolve).with(:mtu).and_return(value)
    end

    it 'return mtu fact' do
      expect(fact.call_the_resolver)
        .to be_an_instance_of(Facter::ResolvedFact)
        .and have_attributes(name: 'networking.mtu', value: value)
    end

    context 'when mtu can not be retrieved' do
      let(:value) { nil }

      it 'returns nil' do
        expect(fact.call_the_resolver)
          .to be_an_instance_of(Facter::ResolvedFact).and have_attributes(name: 'networking.mtu', value: value)
      end
    end
  end
end
