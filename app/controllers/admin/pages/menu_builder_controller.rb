class Admin::Pages::MenuBuilderController < ApplicationController
  def index
    @menus = Menu.all
  end

  def show
    @menu = Menu.find(params[:id])
  end

  def new
    @menu = Menu.new
  end
  
  def create
    @menu = Menu.new(params[:menu])
    if @menu.save
      flash[:notice] = "Menu bylo vytvořeno!"
      redirect_to admin_menus_url
    else
      render :action => :new
    end
  end
  
  def edit
    @menu = Menu.find(params[:id])
  end
  
  def update
    @menu = Menu.find(params[:id])
    if @menu.update_attributes(params[:menu])
      flash[:notice] = "Menu bylo upraveno!"
      redirect_to admin_menus_url
    else
      render :action => :edit
    end
  end
  
  def destroy
    @menu = Menu.find(params[:id])
    if @menu.destroy
      flash[:notice] = "Menu bylo odstraněno!"
    end
    redirect_to admin_menus_url
  end
  
  def add_child
    @menu = Menu.find(params[:id])
    @menu_item = MenuItem.new
  end
  
  def process_add_child
    @menu = Menu.find(params[:id])
    @menu_item = MenuItem.new(params[:menu_item])
    if @menu_item.save
      flash[:notice] = "Položka menu byla přidána!"
      @menu.menu_items << @menu_item
      redirect_to admin_show_menu_url( @menu )
    else
      render :action => :add_child
    end
  end
  
  def remove_child
    @menu_item = MenuItem.find(params[:id])
    menu = @menu_item.menu
    if @menu_item.destroy
      flash[:notice] = "Položka menu byla odstraněna!"
    end
    redirect_to admin_show_menu_url( menu )
  end
end
