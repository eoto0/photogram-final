class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.order(:username)
  end

  def show
    @user = User.find_by!(username: params[:id])  # 🔁 UPDATED

    is_owner    = current_user == @user
    is_public   = !@user.private?
    is_follower = FollowRequest.exists?(sender: current_user, recipient: @user, status: "accepted")

    if is_public || is_owner || is_follower
      @own_photos = @user.photos.order(created_at: :desc)
      @can_view_profile = true

      if is_owner
        @pending_follow_requests = @user.received_follow_requests.where(status: "pending")
      end
    else
      @can_view_profile = false
    end
  end

  def feed
    @user = User.find_by!(username: params[:id])  # 🔁 UPDATED

    accepted_ids = @user.sent_follow_requests
                        .where(status: "accepted")
                        .pluck(:recipient_id)

    @feed_photos = Photo
                     .where(owner_id: accepted_ids)
                     .includes(:owner)
                     .order(created_at: :desc)
  end

  def discover
    @user = User.find_by!(username: params[:id])  # 🔁 UPDATED

    followed_user_ids = @user.following
                             .where(follow_requests: { status: "accepted" })
                             .pluck(:id)

    @discovery_photos = Photo
                          .joins(:likes)
                          .where(likes: { fan_id: followed_user_ids })
                          .distinct
                          .order(created_at: :desc)
  end
end
