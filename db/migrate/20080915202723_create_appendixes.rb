class CreateAppendixes < ActiveRecord::Migration
  def self.up
    create_table :appendixes do |t|
      t.string	:filename, :thumbnail, :content_type
      t.integer :size, :width, :height, :parent_id, :page_id

			t.string :class_name, { :default => 'Image' }
			t.timestamps
    end
    
    add_index :appendixes, :filename
    add_index :appendixes, :class_name
  end

  def self.down
    drop_table :appendixes
  end
end
