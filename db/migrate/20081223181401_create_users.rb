class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :full_name
      t.string :login
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token
      t.integer :login_count
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
      t.string :perishable_token, :default => "", :null => false

      t.timestamps
    end
    
    add_index :users, :login
    add_index :users, :email
    add_index :users, :perishable_token
  end

  def self.down
    drop_table :users
  end
end
