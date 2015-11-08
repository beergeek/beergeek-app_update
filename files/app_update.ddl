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
          :type         => :string,
          :validation   => '^[a-zA-Z\-_\d]+$',
          :optional     => false,
          :maxlength    => 30
  input   :host,
          :description  => "Host URL of repo server uses to retrieve code base",
          :prompt       =>  "Repo Server URL",
          :type         =>  :string,
          :validation   =>  '^[a-zA-Z:\/\-_\.\d]+$',
          :optional     => false,
          :maxlength    => 50
  input   :package,
          :description  => "Name of the package to update code base",
          :prompt       => "Application",
          :type         => :string,
          :validation   =>  '^[a-zA-Z\-_\.\d]+$',
          :optional     => false,
          :maxlength    => 50
  input   :version,
          :description  => "Version to upgrade to, use semver or 'latest'",
          :prompt       => "Version",
          :type         => :string,
          :validation   =>  '^[a-zA-Z\-_\.\d]+$',
          :optional     => false,
          :maxlength    => 20
end
