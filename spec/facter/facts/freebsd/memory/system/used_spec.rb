# frozen_string_literal: true

describe Facts::Freebsd::Memory::System::Used do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Freebsd::Memory::System::Used.new }

    let(:resolver_result) { 1024 }
    let(:fact_value) { '1.00 KiB' }

    before do
      allow(Facter::Resolvers::Freebsd::SystemMemory).to receive(:resolve).with(:used_bytes).and_return(resolver_result)
    end

    it 'returns a memory.system.used fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'memory.system.used', value: fact_value)
    end
  end
end
