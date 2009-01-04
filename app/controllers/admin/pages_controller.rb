class Admin::PagesController < AdminController
  permission_required :edit_content, { :except => [:wysiwyg, :destroy] }
  permission_required :destroy_content, { :only => [ :destroy ] }
  
	def index
	end

	def new
		@page = Page.new
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
		@page = Page.find( params[:id] )
		unless @page.slug == '/' or (not @page.class == Page)
			flash[:notice] = "Stránka \"#{@page.title}\" byla smazána"
			@page.destroy
		end

		redirect_to admin_pages_url
	end

	def wysiwyg
		@css = Css.all
		@css_string = ""
		@css.each do |css|
			@css_string << css.body
		end
		
		respond_to do |format|
			format.html { render :action => "wysiwyg", :layout => false }
    end
	end

	def tags
		respond_to do |format|
			format.html { render :action => "tags", :layout => false }
    end
	end

	def add_appendix
		respond_to do |format|
			format.js
    end
	end

	def remove_appendix
		@appendix = Annex.find(params[:id])
		@page = @appendix.page
		@appendix.destroy

		respond_to do |format|
			format.js
    end
	end

	def pageslist
		session[:selected_language] = params[:lang] || "cz"

		respond_to do |format|
			format.js
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
