class PopulateDb < ActiveRecord::Migration
  def self.up
		# INITIAL DATA
		say						"loading initial data ..."
		Configuration.create :key => 'site.title', :value => '"svenMS"'
		Configuration.create :key => 'site.langs', :value => '["cz"]', :option_type => 'check', :values => '[["czech", "cz"],["english", "en"]]'
    Configuration.create :key => 'site.description', :value => '"Content Management System napsany v Ruby on Rails"'
    Configuration.create :key => 'site.keywords', :value => '"web,programovani,rails,ruby,ruby on rails,cms,content,web 2.0"'
    
		Layout.create :name => 'Standardní', :content => '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd"><html><head><title><s:full_title /></title><s:stylesheets /><meta http-equiv="content-type" content="text/html; charset=utf-8" /></head><body><div class="main"><a id="top"></a><div class="topmenu"><s:menu /></div><div class="main-content"><s:template_content /></div><div style="clear: both;"></div></div></body></html>'
		Layout.create :name => 'Prázdný', :content => '<s:template_content />', :content_type => 'text/css'
		
     # VERSIONS
    #Page.create_versioned_table
    
		# INITIAL DATA
		say						"loading initial data ..."
		Page.create :title => 'Domů', :slug => '/', :body => '<h1>Prosím, uprav mne !</h1>', :layout_id => 1, :language => "cz", :status_id => 100
		FileNotFoundPage.create :title => '404: Stránka nenalezena', :slug => 'stranka-nenalezena', :body => 'Hledaná stránka nebyla nalezena..', :layout_id => 1, :language => "cz", :status_id => 100
    Css.create :title => 'Styl vzhledu', :slug => 'css', :body => 'body { color: white; background-color: black; }', :layout_id => 2, :language => "cz", :status_id => 100
    SearchPage.create :title => 'Hledání', :slug => 'hledani', :body => '', :layout_id => 1, :language => "cz", :status_id => 100, :template_id => 2
    
	  Page.all(:conditions => [ "id > 1" ]).each do |page|
	    page.move_to_child_of(Page.find(1))
	  end
	  
    ContentTemplate.create :name => 'Standardní', :content => '<s:content />'
    ContentTemplate.create :name => 'Hledání', :content => '<s:content /><br /><br />HLEDÁNÍ'
    
    @admin_pass = User.generate_password
    @admin = User.new :full_name => 'Jan Komzák', :login => 'admin', :email => 'komzak@comz.cz'
    @admin.password = @admin_pass
    @admin.password_confirmation = @admin_pass
    @admin.save
    
    say "Admin password: #{@admin_pass}"
    @admin.deliver_email_with_password!( @admin_pass )
    @comz = User.name :full_name => 'Jan Komzák', :login => 'comz', :email => 'komzak@gmail.com'
    @comz.password = @admin_pass
    @comz.password_confirmation = @admin_pass
    @comz.save
    
    Permission.create :identifier => 'edit_content'
    Permission.create :identifier => 'destroy_content'
    Permission.create :identifier => 'manage_users'
    Permission.create :identifier => 'manage_options'
    Permission.create :identifier => 'manage_plugins'
    
    @admin.permission_ids = [ 1, 2, 3, 4, 5 ]
    @comz.permission_ids = [ 1, 5 ]
	  
    Menu.create :name => 'Hlavní menu', :description => 'Všechny stránky jako položky menu', :identifier => 'mainmenu'
  end

  def self.down
    #Page.destroy_versioned_table
  end
end
