class Admin::UsersController < ApplicationController
  permission_required :manage_users, :except => [ :edit, :update, :forgotten_password, :regenerate_password ]
  before_filter :permissions
  before_filter :load_user_using_perishable_token, :only => [ :restore_password, :process_restore_password ]
  
  def index
    @users = User.all
  end

  def show
    @user = @current_user
  end
  
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:notice] = "Účet vytvořen!"
      redirect_back_or_default admin_users_url
    else
      render :action => :new
    end
  end

  def edit
    @user = current_user
    @user = User.find(params[:id]) if current_user.has_permission?('manage_users')
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    @user = User.find(params[:id]) if current_user.has_permission?('manage_users')
    if @user.update_attributes(params[:user])
      flash[:notice] = "Účet upraven!"
      redirect_back_or_default admin_users_url
    else
      render :action => :edit
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    unless @user.login == "admin"
      if @user.destroy
        flash[:notice] = "Účet byl odstraněn!"
      end
      redirect_back_or_default admin_users_url
    end
  end
  
  def forgotten_password
  end

  def process_forgotten_password
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:notice] = "Instrukce pro resetování hesla Vám byly zaslány na email.<br />Zkontrolujte si Vaši schránku."
      redirect_back_or_default admin_url
    else
      flash[:error] = "Žádný uživatel s tímto emailem neexistuje."
      render :action => :forgotten_password
    end
  end
  
  def restore_password
  end
  
  def process_restore_password
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      flash[:notice] = "Heslo bylo upraveno."
      redirect_to account_url
    else
      render :action => :restore_password
    end
  end
  
  private
    def permissions
      @permissions = Permission.all
    end
    
    def load_user_using_perishable_token
      @user = User.find_using_perishable_token(params[:id])
      unless @user
        flash[:error] = "Omlouvám se, ale žádný takový účet neexistuje. Zkuste zkopírovat adresu z emailu, nebo celý proces zopakovat."
        redirect_to admin_url
      end
    end
end
