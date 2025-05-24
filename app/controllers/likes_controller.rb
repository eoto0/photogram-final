class LikesController < ApplicationController
  # POST /photos/:photo_id/likes
  def create
    photo = Photo.find(params[:photo_id])
    like  = photo.likes.find_or_initialize_by(fan: current_user)

    if like.persisted?
      redirect_back fallback_location: root_path,       # <= root
                    alert: "You've already liked this photo."
    else
      like.save
      redirect_to root_path,                            # <= root + notice
                  notice: "Like created successfully."
    end
  end

  # DELETE /photos/:photo_id/likes/:id
  def destroy
    current_user.likes.find(params[:id]).destroy
    redirect_to root_path,                              # <= root + alert
                alert: "Like deleted successfully."
  end
end
