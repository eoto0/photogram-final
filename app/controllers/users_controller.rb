class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.order(:username)
  end

def show
  @user = User.find_by!(username: params[:id])

  is_owner = user_signed_in? && current_user == @user
  is_public = !@user.private?
  is_follower = user_signed_in? && FollowRequest.exists?(sender: current_user, recipient: @user, status: "accepted")

  @can_view_profile = is_public || is_owner || is_follower
  
  if @can_view_profile
    @own_photos = @user.photos.order(created_at: :desc)
  else
    @own_photos = []
  end

  if is_owner
    @pending_follow_requests = @user.received_follow_requests.where(status: "pending")
  end
end

def feed
  @user = User.find_by!(username: params[:id])

  accepted_ids = @user.sent_follow_requests.where(status: "accepted").pluck(:recipient_id)
  
  if accepted_ids.any?
    @photos = Photo.where(owner_id: accepted_ids).includes(:owner).order(created_at: :desc)
  else
    @photos = Photo.none
  end
end

  def liked_photos
    @user = User.find_by!(username: params[:id])
    @liked_photos = @user.likes.includes(photo: :owner).order(created_at: :desc).map(&:photo)
  end

  def discover
    @user = User.find_by!(username: params[:id])
    followed_user_ids = @user.following.where(follow_requests: { status: "accepted" }).pluck(:id)

    @discovery_photos = Photo.joins(:likes)
                              .where(likes: { fan_id: followed_user_ids })
                              .distinct
                              .order(created_at: :desc)
  end
end
