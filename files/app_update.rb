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

        @puppet_command = @config.pluginconf.fetch("puppet.command", "puppet agent")
        @puppet_service = @config.pluginconf.fetch("puppet.windows_service", "puppet")
        @puppet_splaylimit = Integer(@config.pluginconf.fetch("puppet.splaylimit", 30))
        @puppet_splay = @config.pluginconf.fetch("puppet.splay", "false")

        @puppet_agent = Util::PuppetAgentMgr.manager(configfile, @puppet_service)
      end

      def control_puppet(state = 'enable')
        begin
          Log.info("#{state} Puppet")
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
          Log.info("#{cmd_hash} the resource of #{resource_type} with the title #{resource_name}: #{result}")
        rescue => e
          raise "Could not manage resource of #{resource_type} with the title #{resource_name}: #{e.to_s}"
        end
      end

      action 'deploy_app_update' do
        begin
          control_puppet('disable')
          resource_manage('service', request[:service], {'ensure' => 'stopped'})
          resource_manage('yumrepo','app_data',{'ensure' => 'present', 'enabled' => '1', 'gpgcheck' => '0', 'baseurl' => 'http://repo.puppetlabs.vm/'})
          resource_manage('package', request[:app], {'ensure' => request[:version]})
          resource_manage('yumrepo','app_data',{'ensure' => 'present', 'enabled' => '0', 'gpgcheck' => '0', 'baseurl' => 'http://repo.puppetlabs.vm/'})
          resource_manage('service', request[:service], {'ensure' => 'running'})
          reply[:exitcode] = 0
          # This would call the BuildAPIClient to get the current onbaord codebase version
          x = ::Puppet::Resource.indirection.find("package/#{request[:app]}")
          if x[:ensure] != 'absent'
            reply[:out] = x[:ensure]
          else
            reply[:out] = 'absent'
          end
        rescue => e
          Log.error(e.to_s)
          reply.fail(reply[:status] = e.to_s)
        ensure
          control_puppet('enable')
        end
      end
    end
  end
end
