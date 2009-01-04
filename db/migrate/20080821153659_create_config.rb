class CreateConfig < ActiveRecord::Migration
  def self.up
		say						"CONFIG"
		say					  "-------------"
		
    create_table :config do |config|
      config.string :key, :value
      config.string :option_type, { :default => 'text' }
      config.string :values
    end
		# INDEXES
		say						"adding indexes ..."
		add_index :config, :key
		add_index :config, :value
		
		Configuration.create :key => 'site.title', :value => '"svenMS"'
		Configuration.create :key => 'site.langs', :value => '["cz"]', :option_type => 'check', :values => '[["czech", "cz"],["english", "en"]]'
    Configuration.create :key => 'site.description', :value => '"Content Management System napsany v Ruby on Rails"'
    Configuration.create :key => 'site.keywords', :value => '"web,programovani,rails,ruby,ruby on rails,cms,content,web 2.0"'
  end

  def self.down
    drop_table :config
  end
end
