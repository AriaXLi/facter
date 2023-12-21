# frozen_string_literal: true

describe Facts::Solaris::Os::Release do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Solaris::Os::Release.new }

    let(:value) { { 'full' => '10_u11', 'minor' => '11', 'major' => '10' } }

    before do
      allow(Facter::Resolvers::Solaris::OsRelease).to receive(:resolve).with(:full).and_return('10_u11')
      allow(Facter::Resolvers::Solaris::OsRelease).to receive(:resolve).with(:major).and_return('10')
      allow(Facter::Resolvers::Solaris::OsRelease).to receive(:resolve).with(:minor).and_return('11')
    end

    it 'returns os.release, operatingsystemmajrelease and operatingsystemrelease fact' do
      expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
        contain_exactly(an_object_having_attributes(name: 'os.release', value: value),
                        an_object_having_attributes(name: 'operatingsystemmajrelease',
                                                    value: value['major'], type: :legacy),
                        an_object_having_attributes(name: 'operatingsystemrelease', value: value['full'],
                                                    type: :legacy))
    end
  end
end
