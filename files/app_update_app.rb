#
# MCO Agent to update application code base
# Written by Brett Gray
# brett.gray@puppetlabs.com
#

module MCollective
  class Application
    class App_update < MCollective::Application
      description 'Update code base for an application'

      option  :service,
              :description => 'Service to stop and start',
              :arguments   => ['-s SERVICE','--service SERVICE'],
              :type        => String,
              :required    => true
      option  :host,
              :description  => 'Host URL of rep server',
              :arguments   => ['-o HOST','--host HOST'],
              :type        => String,
              :required    => true
      option  :package,
              :description  => 'Name of the application to update code base',
              :arguments   => ['-p PACKAGE_NAME','--package PACKAGE_NAME'],
              :type        => String,
              :required    => true
      option  :version,
              :description  => "Version to upgrade to, use semver or 'latest'",
              :arguments   => ['-n VERSION','--package_version VERSION'],
              :type        => String,
              :required    => true

      def main
        mc = rpcclient('app_update')

        output = mc.deploy_app_update(:service => configuration[:service],:package => configuration[:package],:version => configuration[:version],:host => configuration[:host], :options => options)
        sender_width = output.map{|s| s[:sender]}.map{|s| s.length}.max + 3

        output.each do |result|
          pattern = "%%%ds: %%s" % sender_width

          puts(pattern % [result[:sender], result[:data][:out]])
          #puts result[:data][:out]
        end

        printrpcstats
      end
    end
  end
end
