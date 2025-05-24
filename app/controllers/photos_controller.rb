class PhotosController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    # public photos only
    @photos = Photo.
      joins(:owner).
      where(users: { private: false }).
      order(created_at: :desc).
      includes(:owner)
  end

  def show
    @photo     = Photo.find(params[:id])
    @comments  = @photo.comments.includes(:author)
    @new_like  = Like.new
    @new_comment = Comment.new
  end

  # ───────────────────────── create / destroy for owner ────────────
  def create
    photo            = Photo.new(photo_params)
    photo.owner       = current_user

    if photo.save
      redirect_to root_path, notice: "Photo created successfully."
    else
      redirect_to root_path, alert: photo.errors.full_messages.to_sentence
    end
  end

  def destroy
    photo = current_user.photos.find(params[:id])
    photo.destroy
    redirect_to root_path, alert: "Photo deleted."
  end

  private

  def photo_params
    params.require(:photo).permit(:image, :caption)
  end
end
