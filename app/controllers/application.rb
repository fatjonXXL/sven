class ApplicationController < ActionController::Base
	layout "sven"
	
  protect_from_forgery # :secret => '62f86ba559f3652e400be19d048495c8'
  filter_parameter_logging :password, :password_confirmation
  
  helper_method :current_user, :current_user_session
  helper :all
	before_filter :languagable
  
	def rescue_action_in_public(exception)
    case exception
      when ActiveRecord::RecordNotFound, ActionController::UnknownController, ActionController::UnknownAction, ActionController::RoutingError, NoMethodError
        render_not_found_page
			else
				super
    end
  end

	def render_not_found_page
		FileNotFoundPage.process(request, response)
		@performed_render = true
	end 
    
  protected
		def languagable
			@language ||= Sven::LanguageHolder.new			
		end
end
