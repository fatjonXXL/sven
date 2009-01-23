class User < ActiveRecord::Base
  has_and_belongs_to_many :permissions
  acts_as_authentic :logged_in_timeout => 60.minutes, :password_field_validates_presence_of_options => { :on => :update, :if => :update_password? }
  
  attr_accessor :dont_update_password
  
  def current_or_last_ip
    current_login_ip || last_login_ip
  end

  def current_or_last_at
    current_login_at || last_login_at
  end
  
  def has_permission?(permission)
    return true if self.permissions.find( :first, :conditions => { :identifier => permission.to_s } )
    return false
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Notifier.deliver_password_reset_instructions( self )
  end
  
  def deliver_email_with_password!( password )
    Notifier.deliver_email_with_password( self, password )
  end
  
  def self.generate_password
    Base64.encode64( Digest::SHA1.digest( "#{rand(1<<64)}/#{Time.now.to_f}/#{Process.pid}" ) )[0..8]
  end
  
  private
    def update_password?
      not @dont_update_password
    end
end
