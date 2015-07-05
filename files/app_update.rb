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
        @puppet_splay = @config.pluginconf.fetch("puppet.splay", "true")

        @puppet_agent = Util::PuppetAgentMgr.manager(configfile, @puppet_service)
      end

      def control_puppet(state = 'enable')
        begin
          Log.info('Disabling Puppet')
          if state == 'disable'
            agent_msg = @puppet_agent.disable!
          else
            agent_msg = @puppet_agent.enable!
          end
        rescue => e
          raise "Could not disable Puppet: #{e.to_s}"
        end
      end

      def service_manage(svc_name, cmd)
        begin
          x = ::Puppet::Resource.new('service', svc_name, :parameters => {'ensure' => cmd})
          result = ::Puppet::Resource.indirection.save(x)
          Log.info("#{cmd} the service of #{svc_name}: #{result}")
        rescue => e
          raise "Could not manage service #{svc_name}: #{e.to_s}"
        end
      end

      action 'deploy_app_update' do
        begin
          control_puppet('disable')
          service_manage(request[:service], 'stopped')
          Log.info("BuildAPIClient -i /home/buildapiclient/.credentials https://#{request[:host]}:1234/#{request[:app]}/#{request[:version]} #{request[:destination]}")
          service_manage(request[:service], 'running')
          reply[:exitcode] = 0
          # This would call the BuildAPIClient to get the current onbaord codebase version
          reply[:out] = 'Local code base version: xyz'
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
