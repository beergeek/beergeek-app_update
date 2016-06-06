require 'spec_helper'
describe 'app_update' do
  let(:pre_condition) {
    [
      'service { "mcollective": }',
      'service { "pe-mcollective": }'
    ]
  }

  context 'with defaults for all parameters on RedHat' do
    let(:facts) {
      {
        :osfamily   => 'RedHat',
      }
    }
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

  context 'with defaults for all parameters on RedHat with AIO Agent' do
    let(:facts) {
      {
        :os                 => { 'familt' => 'RedHat'},
        :aio_agent_version  => '1.0.1',
      }
    }
    it { should contain_class('app_update') }

    it {
      should contain_file('app_update.ddl').with(
        'ensure'  => 'file',
        'path'    => '/opt/puppetlabs/mcollective/plugins/mcollective/agent/app_update.ddl',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/app_update/app_update.ddl',
      ).that_notifies('Service[mcollective]')
    }

    it {
      should contain_file('app_update.rb').with(
        'ensure'  => 'file',
        'path'    => '/opt/puppetlabs/mcollective/plugins/mcollective/agent/app_update.rb',
        'owner'   => 'root',
        'group'   => 'root',
        'mode'    => '0644',
        'source'  => 'puppet:///modules/app_update/app_update.rb',
      ).that_notifies('Service[mcollective]')
    }
  end
end
