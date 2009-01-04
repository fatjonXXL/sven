class CreateLayouts < ActiveRecord::Migration
  def self.up
		say						"LAYOUTS"
		say					  "-------------"

    create_table :layouts do |layout|
      layout.string :name
      layout.text :content
			layout.string :content_type, {:default => 'text/html'}
    end
  end

  def self.down
    drop_table :layouts
  end
end