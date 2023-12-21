# frozen_string_literal: true

describe Facts::Freebsd::Memory::Swap::AvailableBytes do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Freebsd::Memory::Swap::AvailableBytes.new }

    let(:value) { 1024 * 1024 }
    let(:value_mb) { 1 }

    before do
      allow(Facter::Resolvers::Freebsd::SwapMemory).to receive(:resolve).with(:available_bytes).and_return(value)
    end

    it 'returns a fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
        contain_exactly(an_object_having_attributes(name: 'memory.swap.available_bytes', value: value),
                        an_object_having_attributes(name: 'swapfree_mb', value: value_mb, type: :legacy))
    end
  end
end
