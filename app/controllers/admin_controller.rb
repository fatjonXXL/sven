class AdminController < ApplicationController
  permission_required :no_permission
  
  def show
  end
  
  def languagable
    I18n.locale = :cz
  end
end
