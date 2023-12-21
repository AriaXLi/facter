# frozen_string_literal: true

describe Facts::Aix::Memory::Swap::Used do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Aix::Memory::Swap::Used.new }

    let(:resolver_value) { { available_bytes: 2_332_425, total_bytes: 2_332_999, used_bytes: 1024 } }
    let(:value) { '1.00 KiB' }

    before do
      allow(Facter::Resolvers::Aix::Memory).to \
        receive(:resolve).with(:swap).and_return(resolver_value)
    end

    it 'returns swap used memory fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'memory.swap.used', value: value)
    end
  end
end
