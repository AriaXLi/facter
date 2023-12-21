# frozen_string_literal: true

describe Facts::Solaris::DhcpServers do
  subject(:fact) { Facts::Solaris::DhcpServers.new }

  before do
    allow(Facter::Resolvers::Solaris::Networking).to receive(:resolve).with(:interfaces).and_return(interfaces)
    allow(Facter::Resolvers::Solaris::Networking).to receive(:resolve).with(:dhcp).and_return(dhcp)
  end

  describe '#call_the_resolver' do
    let(:value) { { 'system' => '10.16.122.163', 'eth0' => '10.16.122.163', 'en1' => '10.32.10.163' } }
    let(:interfaces) { { 'eth0' => { dhcp: '10.16.122.163' }, 'en1' => { dhcp: '10.32.10.163' } } }
    let(:dhcp) { '10.16.122.163' }

    it 'returns dhcp_servers' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'dhcp_servers', value: value, type: :legacy)
    end
  end

  describe '#call_the_resolver when resolver returns nil' do
    let(:interfaces) { nil }
    let(:dhcp) { nil }

    it 'returns nil' do
      expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
        have_attributes(name: 'dhcp_servers', value: nil, type: :legacy)
    end
  end
end
