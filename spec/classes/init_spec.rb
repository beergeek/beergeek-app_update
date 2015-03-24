require 'spec_helper'
describe 'app_update' do

  context 'with defaults for all parameters' do
    it { should contain_class('app_update') }

    it {
      should contain_file('app_update.ddl').with(
        'ensure'  => 'file',
        'path'    => '/opt/puppet/libexec/mcollective/mcollective/agent/app_update.ddl',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/app_update/app_update.ddl',
      ).that_notifies('Service[pe-mcollective]')
    }

    it {
      should contain_file('app_update.rb').with(
        'ensure'  => 'file',
        'path'    => '/opt/puppet/libexec/mcollective/mcollective/agent/app_update.rb',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/app_update/app_update.rb',
      ).that_notifies('Service[pe-mcollective]')
    }
  end
end
