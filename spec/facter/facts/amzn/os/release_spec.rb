# frozen_string_literal: true

describe Facts::Amzn::Os::Release do
  describe '#call_the_resolver' do
    subject(:fact) { Facts::Amzn::Os::Release.new }

    before do
      allow(Facter::Resolvers::Amzn::OsReleaseRpm).to receive(:resolve)
        .with(:version)
        .and_return(value)
    end

    context 'when version is retrieved from rpm' do
      let(:value) { '2.13.0' }
      let(:release) { { 'full' => '2.13.0', 'major' => '2', 'minor' => '13' } }

      it 'calls Facter::Resolvers::Amzn::OsReleaseRpm with version' do
        fact.call_the_resolver
        expect(Facter::Resolvers::Amzn::OsReleaseRpm).to have_received(:resolve)
          .with(:version)
      end

      it 'returns os release fact' do
        expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
          contain_exactly(an_object_having_attributes(name: 'os.release', value: release),
                          an_object_having_attributes(name: 'operatingsystemmajrelease',
                                                      value: release['major'], type: :legacy),
                          an_object_having_attributes(name: 'operatingsystemrelease',
                                                      value: release['full'], type: :legacy))
      end
    end

    context 'when version is retrieved from os-release file' do
      let(:value) { nil }
      let(:os_release) { '2' }
      let(:release) { { 'full' => '2', 'major' => '2' } }

      before do
        allow(Facter::Resolvers::OsRelease).to receive(:resolve).with(:version_id).and_return(os_release)
      end

      it 'calls Facter::Resolvers::OsRelease with version' do
        fact.call_the_resolver
        expect(Facter::Resolvers::OsRelease).to have_received(:resolve).with(:version_id)
      end

      it 'returns os release fact' do
        expect(fact.call_the_resolver).to be_an_instance_of(Array).and \
          contain_exactly(an_object_having_attributes(name: 'os.release', value: release),
                          an_object_having_attributes(name: 'operatingsystemmajrelease',
                                                      value: release['major'], type: :legacy),
                          an_object_having_attributes(name: 'operatingsystemrelease',
                                                      value: release['full'], type: :legacy))
      end

      context 'when version can\'t be retrieved' do
        let(:os_release) { nil }

        it 'returns os release fact as nil' do
          expect(fact.call_the_resolver).to be_an_instance_of(Facter::ResolvedFact).and \
            have_attributes(name: 'os.release', value: nil)
        end
      end
    end
  end
end
