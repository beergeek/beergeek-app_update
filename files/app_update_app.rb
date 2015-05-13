module MCollective
  class Application
    class App_update < MCollective::Application
      description "Update code base for an application"

      option  :service,
              :description => "Service to stop and start",
              :arguments   => ["-s SERVICE","--service SERVICE"],
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
