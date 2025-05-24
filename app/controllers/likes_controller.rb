class LikesController < ApplicationController
  def create
    photo = Photo.find(params[:photo_id])

    like = photo.likes.find_or_initialize_by(fan: current_user)

    if like.persisted?
      redirect_back fallback_location: photo_path(photo),
                    alert: "You've already liked this photo."
    else
      like.save
      redirect_back fallback_location: photo_path(photo),
                    notice: "Photo liked!"
    end
  end

  def destroy
    like = current_user.likes.find(params[:id])
    like.destroy
    redirect_back fallback_location: root_path,
                  alert: "Like removed."
  end
end
