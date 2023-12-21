# frozen_string_literal: true

describe Facts::Aix::Memory::System::Total do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Aix::Memory::System::Total.new }

    let(:resolver_value) { { available_bytes: 2_332_425, total_bytes: 2_332_999, used_bytes: 1024 } }
    let(:value) { '2.22 MiB' }

    before do
      allow(Facter::Resolvers::Aix::Memory).to \
        receive(:resolve).with(:system).and_return(resolver_value)
    end

    it 'returns system total memory fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
        contain_exactly(an_object_having_attributes(name: 'memory.system.total', value: value),
                        an_object_having_attributes(name: 'memorysize', value: value, type: :legacy))
    end
  end
end
