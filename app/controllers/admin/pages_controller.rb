class Admin::PagesController < ApplicationController
  permission_required :edit_content, :except => [ :destroy ]
  
	def index
	end

	def new
		@page = Page.new
		@page.language = Configuration['site.langs'].first if Configuration['site.langs'].size == 1
	end

	def create
		@page = params[:page][:class_name].constantize.new(params[:page])
		
		flash[:notice] = "Stránka byla vytvořena" if @page.valid?
		respond_to do |format|
			if @page.save
				@page.move_to_child_of(Page.find(params[:parent])) unless params[:parent].blank?
				make_appendixes params[:appendix], @page.id

				if params[:save_and_continue].blank?
					format.html { redirect_to(admin_pages_url) }
				else
					format.html { render :action => 'edit' }
				end
			else
				format.html { render :action => 'new' }
			end
    end
  end

	def edit
		@page = Page.find(params[:id])
	end
	
	def edit_parent
	 @page = Page.find(params[:id])
	 @pagelist = Page.all( :conditions => { :class_name => 'Page' } ) - [@page, @page.parent]
	end

	def update
		@page = Page.find(params[:id])

    session[:last_body] = nil
		flash[:notice] = "Stránka byla upravena" if @page.valid?
		respond_to do |format|
		  if params[:page]
		    @page.class_name = params[:page][:class_name]
		    params[:page][:slug] = "/" if @page.slug == "/"
		  end
			if @page.update_attributes(params[:page])
				@page.move_to_child_of(Page.find(params[:parent])) if ( not params[:parent].blank? ) and params[:parent].to_i > 0 and ( not @page.slug == "/" )
				make_appendixes params[:appendix], @page.id
				
				if params[:save_and_continue].blank?
					format.html { redirect_to(admin_pages_url) }
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
	    @page = Page.find( params[:id] )
	    unless @page.slug == '/' or (not @page.class == Page)
		    flash[:notice] = "Stránka \"#{@page.title}\" byla smazána"
		    @page.destroy
	    end

		  redirect_to admin_pages_url
	  end
	end

	def add_appendix
		respond_to do |format|
		  format.html { render :partial => 'admin/pages/add_appendix', :layout => false }
    end
	end

	def remove_appendix
		@appendix = Annex.find(params[:id])
		@page = @appendix.page
		@appendix.destroy

		respond_to do |format|
		  format.html { render :partial => 'admin/pages/appendixes', :layout => false }
    end
	end

	def pageslist
		session[:selected_language] = params[:lang] || "cz"

		respond_to do |format|
			format.html { render :partial => 'admin/pages/list_pages', :layout => false }
    end
	end
	
	def versions
	  @page = Page.find( params[ :page ] ) if params[ :page ]
	  case params[ :version ].to_i
      when 0
	      body = session[ :last_body ].blank? ? @page.versions.last.body : session[ :last_body ]
      when -1
        session[ :last_body ] = params[ :page_body ]
        body = false
      else
	      body = @page.versions.find( params[ :version ] ).body
	      body = false if body.blank?
	  end
	  
	  respond_to do |format|
	    format.js { render :text => body }
    end
	end
	
	private
	def make_appendixes(appendixes, page)
		unless appendixes.blank?
			for appendix in appendixes
				appendix[:page_id] = page
				appendix[:class_name].constantize.create(appendix)
			end
		end

		true
	end
end
