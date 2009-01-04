class CreatePages < ActiveRecord::Migration
  def self.up
		say					  "PAGES"
		say						"-------------"
		
    create_table :pages do |page|
      page.string :title, :slug, :description, :keywords, :language
      page.text :body
			
			page.string :class_name, {:default => 'Page'}
			
			page.integer :lft, :rgt, :parent_id
			
      page.integer :status_id, { :default => 1 }
      page.integer :layout_id, { :default => 1 }
			page.integer :template_id, { :default => 1 }
			page.integer :author_id, { :default => 1 }
			
      page.timestamps
      page.datetime :deleted_at
    end

		# INDEXES
		say						"adding indexes ..."
		add_index :pages, :title
		add_index :pages, :slug
		add_index :pages, :class_name
    
    Page.transaction do
      # VERSIONS
	    Page.create_versioned_table
	    
  		# INITIAL DATA
  		say						"loading initial data ..."
  		Page.create :title => 'Domů', :slug => '/', :body => '<h1>Prosím, uprav mne !</h1>', :layout_id => 1, :language => "cz", :status_id => 100
  		FileNotFoundPage.create :title => '404: Stránka nenalezena', :slug => 'stranka-nenalezena', :body => 'Hledaná stránka nebyla nalezena..', :layout_id => 1, :language => "cz", :status_id => 100
      Css.create :title => 'Styl vzhledu', :slug => 'css', :body => 'body { color: white; background-color: black; }', :layout_id => 2, :language => "cz", :status_id => 100
      SearchPage.create :title => 'Hledání', :slug => 'hledani', :body => '', :layout_id => 1, :language => "cz", :status_id => 100, :template_id => 2
	    
		  Page.all(:conditions => [ "id > 1" ]).each do |page|
		    page.move_to_child_of(Page.find(1))
		  end
	  end
  end

  def self.down
    Page.destroy_versioned_table
    drop_table :pages
  end
end
