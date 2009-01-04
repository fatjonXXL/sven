class CreatePermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |p|
      p.string :identifier
    end
    
    create_table 'permissions_users', :id => false do |up|
      up.integer :user_id
      up.integer :permission_id
    end
    
    Permission.create :identifier => 'edit_content'
    Permission.create :identifier => 'destroy_content'
    Permission.create :identifier => 'manage_users'
    Permission.create :identifier => 'manage_options'
    Permission.create :identifier => 'manage_plugins'
    
    @admin = User.first
    @admin.permission_ids = [ 1, 2, 3, 4, 5 ]
    @admin.save!
    
    @comz = User.last
    @comz.permission_ids = [ 1, 5 ]
  end

  def self.down
    drop_table :permissions
    drop_table 'permissions_users'
  end
end
