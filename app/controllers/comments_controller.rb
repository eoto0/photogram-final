class CommentsController < ApplicationController
  def create
    photo      = Photo.find(params[:photo_id])
    comment    = photo.comments.build(comment_params)
    comment.author = current_user

    if comment.save
      redirect_to photo_path(photo), notice: "Comment added."
    else
      redirect_to photo_path(photo), alert: comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    comment = current_user.comments.find(params[:id])
    comment.destroy
    redirect_back fallback_location: root_path,
                  alert: "Comment deleted."
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
