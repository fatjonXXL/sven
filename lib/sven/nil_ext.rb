class NilClass  
  def has_permission?(permission)
    ApplicationController.permission_required( permission )
  end
end