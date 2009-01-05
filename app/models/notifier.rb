class Notifier < ActionMailer::Base
  default_url_options[:host] = "sven.free.railshosting.cz"
  
  def password_reset_instructions( user )
    subject       "Zapomenute heslo"
    from          "sven@comz.cz"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token), :sven_host => admin_url, :admin_mail => User.first.email
  end
  
  def email_with_password( user, password )
    subject       "Přihlasovaci udaje"
    from          "sven@comz.cz"
    recipients    user.email
    sent_on       Time.now
    body          :password => password
  end
end