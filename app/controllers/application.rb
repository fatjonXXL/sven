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
    return false if permission.blank?
    
    self.permission_options = options
    self.permission_options[:permission] = permission
    self.permission_options[:user] = true unless self.permission_options[:user].blank?
    
    before_filter :check_permissions, self.permission_options
  end
  
  def check_permissions
    unless self.permission_options[:user] == false
      unless current_user
        flash[:notice] = "Musíte být přihlášeni pro přístup do této sekce."
        redirect_to admin_session_url
        return false
      end
    
      unless self.permission_options[:permission] == :no_permission
        unless current_user.has_permission?( self.permission_options[:permission] )
          flash[:notice] = "Přístup zakázán.<br />Kontaktujte svého administrátora na adrese <a href=\"mailto:#{ User.find(:first, :conditions => { :login => 'admin' }).email }\">#{ User.find(:first, :conditions => { :login => 'admin' }).email }</a>" #<< self.permission_options.inspect << "<br />" << request.request_uri
          redirect_to ( request.env['HTTP_REFERER'] || admin_pages_url )
          return false
        end
      end  
    end
  end
    
  protected
		def languagable
			@language ||= Sven::LanguageHolder.new			
		end
end
