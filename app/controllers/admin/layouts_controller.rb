class Admin::LayoutsController < ApplicationController
  permission_required :edit_content, :except => [ :destroy ]
	
  def index
		@layouts = Layout.all
  end

  def new
		@layout = Layout.new
  end

	def create
		@layout = Layout.new(params[:layout])

		respond_to do |format|
			if @layout.save
				flash[:notice] = "Vzhled byl vytvořen"
				if params[:save_and_continue].blank?
				  format.html { redirect_to(admin_layouts_url) }
				else
					format.html { render :action => 'edit' }
				end
			else
				format.html { render :action => 'new' }
      end
    end
	end

  def edit
		@layout = Layout.find params[:id]
  end

	def update
		@layout = Layout.find params[:id]
		@layout.update_attributes(params[:layout])

		respond_to do |format|
			if @layout.save
				flash[:notice] = "Vzhled byl upraven"
				if params[:save_and_continue].blank?
				  format.html { redirect_to(admin_layouts_url) }
				else
					format.html { render :action => 'edit' }
				end
			else
				format.html { render :action => 'edit' }
      end
    end
	end

	def destroy
	  self.permission_options[:permission] = :destroy_content
	  if check_permissions
		  @layout = Layout.find params[:id]
		    flash[:notice] = "Vzhled #{@layout.name} byl smazán"
		  @layout.destroy

		  respond_to do |format|
			  format.html { redirect_to admin_layouts_url }
      end
    end
	end
end
