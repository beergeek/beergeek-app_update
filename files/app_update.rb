#
# MCO Agent to update application code base
# Written by Brett Gray
# brett.gray@puppetlabs.com
#

$puppet_application_name = :agent
require 'puppet'

module MCollective
  module Agent
    class App_update < RPC::Agent
      activate_when do
        require 'mcollective/util/puppet_agent_mgr'
        true
      end

      def startup_hook
        configfile = @config.pluginconf.fetch("puppet.config", nil)

        @puppet_agent = Util::PuppetAgentMgr.manager(configfile, @puppet_service)
      end

      def control_puppet(state = 'enable')
        begin
          Log.debug("#{state} Puppet")
          if state == 'disable'
            agent_msg = @puppet_agent.disable!
          else
            agent_msg = @puppet_agent.enable!
          end
        rescue => e
          raise "Could not disable Puppet: #{e.to_s}"
        end
      end

      def resource_manage(resource_type, resource_name, cmd_hash)
        begin
          x = ::Puppet::Resource.new(resource_type, resource_name, :parameters => cmd_hash)
          result = ::Puppet::Resource.indirection.save(x)
          Log.debug("#{cmd_hash} the resource of #{resource_type} with the title #{resource_name}: #{result}")
        rescue => e
          raise "Could not manage resource of #{resource_type} with the title #{resource_name}: #{e.to_s}"
        end
      end

      action 'deploy_app_update' do
        begin
          # disable Puppet
          control_puppet('disable')
          # stop the service
          resource_manage('service', request[:service], {'ensure' => 'stopped'})
          # enable the repo
          resource_manage('yumrepo','app_data',{'ensure' => 'present', 'enabled' => '1', 'gpgcheck' => '0', 'baseurl' => request[:host]})
          # upgrade the package
          resource_manage('package', request[:package], {'ensure' => request[:version]})
          # disable the repo
          resource_manage('yumrepo','app_data',{'ensure' => 'present', 'enabled' => '0', 'gpgcheck' => '0', 'baseurl' => request[:host]})
          # restart the service
          resource_manage('service', request[:service], {'ensure' => 'running'})
          # determine which version is actually installed
          x = ::Puppet::Resource.indirection.find("package/#{request[:package]}")
          if x[:ensure] != 'absent'
            reply[:out] = x[:ensure]
          else
            reply[:out] = 'absent'
          end
          reply[:exitcode] = 0
        rescue => e
          Log.error(e.to_s)
          reply.fail(reply[:status] = e.to_s)
        ensure
          # Always ensure Puppet is running
          control_puppet('enable')
        end
      end
    end
  end
end
