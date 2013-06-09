class Admin::Pages::TrashController < ApplicationController
  def index
    @pages = Page.find_only_deleted(:all)
  end
  
  def show
    @page = Page.find(params[:id], :with_deleted => true)
  end

  def restore
    @page = Page.find(params[:id], :with_deleted => true)
    if @page.recover!
      @page.move_to_child_of(Page.first) unless @page.parent
      flash[:notice] = "Stránka byla obnovena"
    end
    
    redirect_to admin_page_trash_url
  end
end
hi was geht ab alter 
