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

      def disable_puppet
	begin
	  Log.info('Disabling Puppet')
          agent_msg = @puppet_agent.disable!
        rescue => e
          reply.fail(reply[:status] = "Could not disable Puppet: %s" % e.to_s)
        end

        return @puppet_agent.status[:enabled]
      end

      def enable_puppet
	begin
	  Log.info('Enabling Puppet')
          agent_msg = @puppet_agent.enable!
        rescue => e
          reply.fail(reply[:status] = "Could not enable Puppet: %s" % e.to_s)
        end

        return @puppet_agent.status[:enabled]
      end

      def service_manage(svc_name, cmd)
        begin
          x = ::Puppet::Resource.new('service', svc_name, :parameters => {'ensure' => cmd})
	        result = ::Puppet::Resource.indirection.save(x)
	        Log.info("#{cmd} the service of #{svc_name}")
        rescue => e
          Log.debug("Issue with performing #{cmd} on #{svc_name} service")
	        reply.fail(reply[:status] = "Could not manage service #{svc_name}: %s" % e.to_s)
          return -1
        end
      end

      action 'deploy_app_update' do
        begin
          disable = disable_puppet
          kill_svc = service_manage(request[:service], 'stopped')
          Log.info('We would do our code base copy here')
          start_svc = service_manage(request[:service], 'running')
          enable = enable_puppet
          reply[:exitcode] = 0
          reply[:out] ='done'
        rescue => e
          enable = enable_puppet
        end
      end
    end
  end
end
