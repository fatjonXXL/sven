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
  end

  def self.down
    drop_table :config
  end
end
