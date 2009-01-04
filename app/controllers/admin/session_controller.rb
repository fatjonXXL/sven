class Admin::SessionController < AdminController
  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Přihlášení proběhlo úspěšně"
      redirect_back_or_default admin_url
    else
      flash[:notice] = "Neplatné uživatelské jméno nebo heslo. Opakujte přihlášení znovu"
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy
    flash[:notice] = "Odhlášení proběhlo úspěšně"
    redirect_back_or_default admin_session_url
  end
end
