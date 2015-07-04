module MCollective
  class Application
    class App_update < MCollective::Application
      description "Update code base for an application"

      option  :service,
              :description => "Service to stop and start",
              :arguments   => ["-s SERVICE","--service SERVICE"],
              :type        => String,
              :required    => true
      option  :host,
              :description  => "Host where the BuildAPIClient get code base",
              :arguments   => ["-h HOST","--host HOST"],
              :type        => String,
              :required    => true
      option  :app,
              :description  => "Name of the application to update code base",
              :arguments   => ["-a APPLICATION","--application APPLICATION"],
              :type        => String,
              :required    => true
      option  :version,
              :description  => "Version to upgrade to, use semver or 'latest'",
              :arguments   => ["-p VERSION","--app_version VERSION"],
              :type        => String,
              :required    => true

      def main
        mc = rpcclient("app_update")

        printrpc mc.deploy_app_update(:service => configuration[:service], :options => options)

        printrpcstats
      end
    end
  end
end
