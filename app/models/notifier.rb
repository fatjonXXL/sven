class Notifier < ActionMailer::Base
  default_url_options[:host] = "sven.prace.rails"

  def password_reset_instructions( user )
    subject       "Zapomenute heslo"
    from          "svenMS"
    recipients    user.email
    sent_on       Time.now
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token), :sven_host => admin_url, :admin_mail => User.first.email
  end
  
  def email_with_password( user, password )
    subject       "Přihlasovaci udaje"
    from          "svenMS"
    recipients    user.email
    sent_on       Time.now
    body          :password => password
  end
end