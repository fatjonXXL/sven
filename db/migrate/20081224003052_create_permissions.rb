class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |p|
      p.string :identifier
    end
    
    create_table 'permissions_users', :id => false do |up|
      up.integer :user_id
      up.integer :permission_id
    end
  end

  def self.down
    drop_table :permissions
    drop_table 'permissions_users'
  end
end
