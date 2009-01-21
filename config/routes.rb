ActionController::Routing::Routes.draw do |map|
#	map.admin '/admin', :controller => 'admin'
	map.resource :admin, :controller => 'admin' do |admin|
    admin.resources :users, :controller => 'admin/users'
    admin.resources :layouts, :controller => 'admin/layouts'
	  admin.resources :templates, :controller => 'admin/templates'
	  #admin.resources :menus, :path_prefix => 'admin/pages', :controller => 'admin/pages/menu_builder', :member => { :add_child => :get, :process_add_child => :post }
	  
	  admin.with_options :controller => 'admin/pages/menu_builder' do |menu|
  		menu.connect							 'pages/menus/',											  :action => 'create', :conditions => { :method => :post }
  		menu.process_add_child		 'pages/menus/:id/process-add-child',		:action => 'process_add_child', :conditions => { :method => :post }
  		menu.menu								   'pages/menus/:id',										  :action => 'update', :conditions => { :method => :put }

  		menu.menus								 'pages/menus',												  :action => 'index'
  		menu.show_menu             'pages/menus/:id/info',                :action => 'show'
  		menu.new_menu						   'pages/menus/new',			                :action => 'new'
  		menu.edit_menu						 'pages/menus/:id',										  :action => 'edit'
  		menu.add_child_menu        'pages/menus/:id/add-child',           :action => 'add_child'
  		menu.remove_child_menu     'pages/menus/:id/remove-child/:child', :action => 'remove_child'
  		menu.destroy_menu				   'pages/menus/:id/destroy',						  :action => 'destroy'
    end
    
	  admin.with_options :controller => 'admin/pages/trash' do |trash|
	    trash.page_trash           'pages/trash/',                :action => 'index'
	    trash.page_trash_show      'pages/trash/:id',             :action => 'show'
	    trash.page_trash_restore   'pages/trash/:id/restore',     :action => 'restore' 
    end
	  
	  admin.with_options :controller => 'admin/pages' do |pages|
  		pages.version              'pages/version',               :action => 'versions'
  		pages.connect							 'pages/',											:action => 'create', :conditions => { :method => :post }
  		pages.page								 'pages/:id',										:action => 'update', :conditions => { :method => :put }

  		pages.connect							 'pages/wysiwyg',								:action => 'wysiwyg'
  		pages.connect							 'pages/tags',									:action => 'tags'
  		pages.add_appendix				 'pages/add_appendix',					:action => 'add_appendix'
  		pages.remove_appendix			 'pages/remove_appendix/:id',		:action => 'remove_appendix'
  		pages.pages_list					 'pages/pageslist/:lang',				:action => 'pageslist'

  		pages.pages								 'pages',												:action => 'index'
  		pages.new_page						 'pages/:parent/add-child',			:action => 'new'
  		pages.edit_page						 'pages/:id',										:action => 'edit'
  		pages.edit_parent_page     'pages/:id/alter-parent',      :action => 'edit_parent'
  		pages.destroy_page				 'pages/:id/destroy',						:action => 'destroy'
    end
	
  	admin.with_options :controller => 'admin/plugins' do |plugins|
  	  plugins.plugins            'plugins',                     :action => 'index'
  	  plugins.edit_plugin        'plugins/:id',                 :action => 'edit'
  	  plugins.info_plugin        'plugins/:id/info',            :action => 'info'
  	  plugins.save_plugin				 'plugins/:id/save',						:action => 'update', :conditions => { :method => :put }
    end

  	admin.with_options :controller => 'admin/options' do |options|
  		options.options						 'options',											:action => 'index'
  		options.save_options			 'options/save',								:action => 'save', :conditions => { :method => :post }
    end

  	admin.with_options :controller => 'admin/session' do |session|
  		session.session						 'session',											:action => 'new'
  		session.user_session			 'session/login',								:action => 'create', :conditions => { :method => :post }
  		session.logout						 'session/logout',							:action => 'destroy'
    end
  end
  
  map.root :controller => 'site', :action => 'show_page', :url => '/'
  map.with_options :controller => 'site' do |site|
		site.change_language			 'change-language/:lang',					:action => 'change_language'
		site.search                'find/:search',                  :action => 'search'
    site.not_found						 'error/404',                     :action => 'not_found'
    site.error								 'error/500',                     :action => 'error'
    
    site.connect							 '*url',                          :action => 'show_page'
  end
end