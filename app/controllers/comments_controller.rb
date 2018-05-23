class CommentsController < ApplicationController
  def create
    @pin = Pin.find(params[:pin_id])
    @comment = @pin.comments.create(params[:comment].permit(:description))
    @comment.user_id = current_user.id
    @comment.user_email = current_user.email

    if @comment.save
      redirect_to pin_path(@pin)
    else
      redirect_to :back
    end
  end

  def destroy
    @pin =  Pin.find(params[:pin_id])
    @comment = @pin.comments.find(params[:id])
    @comment.destroy

    redirect_to pin_path(@pin)
  end
end
