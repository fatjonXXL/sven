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
  end

  def self.down
    drop_table :pages
  end
end
