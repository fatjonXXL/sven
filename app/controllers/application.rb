class ApplicationController < ActionController::Base
  include ExceptionNotifiable

	layout "sven"
	
  protect_from_forgery # :secret => '62f86ba559f3652e400be19d048495c8'
  filter_parameter_logging :password, :password_confirmation
  
  helper_method :current_user, :current_user_session, :available_locales, :current_locale?, :current_page_path
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
	  
	def available_locales
    AVAILABLE_LOCALES
  end
  
  def current_locale?(l)
    l == I18n.locale
  end
  
  def current_page_path(options={})
    url_for( {:controller => self.controller_name, :action => self.action_name}.merge(options) )
  end  
	
  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end  

  def current_user_session
    @current_user_session ||= UserSession.find
  end

  def current_user
    @current_user ||= current_user_session && current_user_session.user
  end
  
  cattr_accessor :permission_options
  def self.permission_required(permission = :no_permission, options = {})
    self.permission_options = { :permission => permission }.merge( options )
    before_filter :check_permissions, self.permission_options
  end
  
  
  def check_permissions
    unless current_user
      store_location
      flash[:error] = "Musíte být přihlášeni pro přístup do této sekce."
      redirect_to admin_session_url
      return false
    end
  
    unless self.permission_options[:permission] == :no_permission
      unless current_user.has_permission?( self.permission_options[:permission] )
        flash[:error] = "Přístup zakázán.<br />Kontaktujte svého administrátora na adrese <a href=\"mailto:#{ User.first(:conditions => { :login => 'admin' }).email }\">#{ User.first(:conditions => { :login => 'admin' }).email }</a>" #<< self.permission_options.inspect << "<br />" << request.request_uri
        redirect_to ( request.env['HTTP_REFERER'] || admin_pages_url )
        return false
      end
    end
    
    return true
  end
    
  protected
		def languagable
      I18n.locale = session[:lang] || I18n.default_locale
		end
end
