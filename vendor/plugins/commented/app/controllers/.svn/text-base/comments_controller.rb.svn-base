class CommentsController < ApplicationController
  def index
    @comments = Comment.all
  end
  
  def new
    @comment = Comment.new
  end
  
  def create
    @comment = Comment.new(params[:comment])
    
    if @comment.save
      flash[:notice] = "Comment saved"
    else
      flash[:notice] = "Comment not saved"
    end  
    
    respond_to do |format|
      format.html { redirect_to :back }
    end
  end
  
  def destroy
  end
end