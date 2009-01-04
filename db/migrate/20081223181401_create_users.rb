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
    
    @admin_pass = "login1986" #User.generate_password
    @admin = User.create :full_name => 'Jan Komzák', :login => 'admin', :email => 'komzak@comz.cz', :password => @admin_pass, :password_confirmation => @admin_pass
    say "Admin password: #{@admin_pass}"
    @admin.deliver_email_with_password!( @admin_pass )
    User.create :full_name => 'Jan Komzák', :login => 'comz', :email => 'komzak@gmail.com', :password => @admin_pass, :password_confirmation => @admin_pass
  end

  def self.down
    drop_table :users
  end
end
