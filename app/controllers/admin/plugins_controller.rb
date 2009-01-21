class Admin::PluginsController < ApplicationController
  permission_required :manage_plugins
  before_filter :find_plugin, :except => [ :index ]
  
  def index
    @plugins = Plugin.all
  end
  
  def info
  end
  
  def edit
  end
  
  def update
    respond_to do |format|
      if Plugin.set_config( params[:id], params[:plugin] )
        flash[:notice] = "Nastavení bylo uloženo"
        format.html { redirect_to admin_info_plugin_url( params[:id] ) }
      else
        flash[:error] = "Nastavení se nepodařilo uložit"
        format.html { render :action => :edit }
      end
    end
  end
  
  private
    def find_plugin
      @plugin = Plugin.find( params[:id] )
    end
end
