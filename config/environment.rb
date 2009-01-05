# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'
ENV['HOME'] ||= '/home/czcomzc'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), "..", "lib/sven")
require File.join(File.dirname(__FILE__), "..", "lib/radius")
require File.join(File.dirname(__FILE__), 'boot')
require File.join(File.dirname(__FILE__), '../vendor/plugins/engines/boot')

Rails::Initializer.run do |config|
  config.gem "mysql"
  config.gem "authlogic"
  
  config.time_zone = 'Prague'
  config.action_controller.session = {
    :session_key => '_sven-778d74_session',
    :secret      => '3e362cf29813da9a0a3085ee3f865e9161201364fd2dcc218f9c17bbca00dd466d5bd8c2a2248127b5f45b09343bb6426bf085ec1152f40ae0eadba6fcf84893'
  }
end

ExceptionNotifier.exception_recipients = %w(komzak@gmail.com komzak@comz.cz)

ActionMailer::Base.delivery_method = :sendmail  
ActionMailer::Base.perform_deliveries = true  
ActionMailer::Base.raise_delivery_errors = true  
ActionMailer::Base.default_charset = "utf-8"
ActionMailer::Base.smtp_settings = {
  :address  => "mail.comz.cz",
  :domain  => 'www.comz.cz',
  :port  => 25, 
  :user_name  => "testing@comz.cz",
  :password  => "testovaci-email",
  :authentication  => :login
}

