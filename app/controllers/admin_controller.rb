class AdminController < ApplicationController
  permission_required :no_permission
  
  def show
    Notifier.deliver_email_with_password(User.last, "login")
  end
  
  def languagable
    I18n.locale = :cz
  end
end
