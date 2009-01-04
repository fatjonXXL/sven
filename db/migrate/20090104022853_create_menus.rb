class CreateMenus < ActiveRecord::Migration
  def self.up
    create_table :menus do |t|
      t.string :name
      t.string :description
      t.string :identifier

      t.timestamps
    end
    
    create_table :menu_items do |t|
      t.string :name, :link
      t.integer :parent_id, :menu_id, :position, :lft, :rgt
      t.integer :published, { :limit => 1 }
      
      t.timestamps
    end
  end

  def self.down
    drop_table :menus
    drop_table :menu_items
  end
end
