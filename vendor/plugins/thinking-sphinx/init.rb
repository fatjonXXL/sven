require 'thinking_sphinx'
require 'action_controller/dispatcher'

if Rails::VERSION::STRING.to_f < 2.1
  ThinkingSphinx::Configuration.new.load_models
end

ActionController::Dispatcher.to_prepare :thinking_sphinx do
  ThinkingSphinx::Configuration.new.load_models
end