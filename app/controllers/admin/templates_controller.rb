class Admin::TemplatesController < AdminController
  permission_required :edit_content, { :except => [ :destroy ] }
  permission_required :destroy_content, { :only => [ :destroy ] }

	def index
		@tmpls = ContentTemplate.all
	end

	def new
		@tmpl = ContentTemplate.new
	end

	def create
		@tmpl = ContentTemplate.new(params[:template])
		
		flash[:notice] = "Šablona byla vytvořena" if @tmpl.valid?
		respond_to do |format|
			if @tmpl.save
				if params[:save_and_continue].blank?
					format.html { redirect_to(admin_templates_url) }
				else
					format.html { render :action => 'edit' }
				end
			else
				format.html { render :action => 'new' }
			end
    end
  end

	def edit
		@tmpl = ContentTemplate.find(params[:id])
	end

	def update
		@tmpl = ContentTemplate.find(params[:id])

		flash[:notice] = "Šablona byla upravena" if @tmpl.valid?
		respond_to do |format|
			if @tmpl.update_attributes(params[:template])
				if params[:save_and_continue].blank?
					format.html { redirect_to(admin_templates_url) }
				else
					format.html { render :action => 'edit' }
				end
			else
				format.html { render :action => 'edit' }
			end
    end
  end

	def destroy
		@tmpl = ContentTemplate.find params[:id]
		@tmpl.destroy

		flash[:notice] = "Šablona \"#{@tmpl.name}\" byla smazána"
		redirect_to admin_templates_url
	end
end
