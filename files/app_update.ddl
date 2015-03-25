metadata :name        => "app_update",
         :description => "updates app code base",
         :author      => "Brett",
         :license     => "GPLv2",
         :version     => "1.1",
         :url         => "https://github.com/beergeek/mco_agents",
         :timeout     => 30

action "deploy_app_update", :description => "deploy_app_update" do
   output :out,
          :description => "Update App Code Base",
          :display_as  => "Return"
  input   :service,
          :description  => "Service to stop/start",
          :prompt       => "Service",
          :type         => string,
          :validation   => '^[a-zA-Z\-_\d]+$',
          :optional     => false,
          :maxlength    => 30
end
