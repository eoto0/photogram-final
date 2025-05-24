class UsersController < ApplicationController
  # The visitor can always see the list of public users and public photos
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @users = User.order(:username)
  end

  def show
    @user       = User.find(params[:id])
    @own_photos = @user.photos.order(created_at: :desc)

    # pending requests only relevant when viewer == user
    if user_signed_in? && current_user == @user
      @pending_follow_requests = @user.received_follow_requests.where(status: "pending")
    end
  end

  # --------------------------------------------------------------------------
  # Extra pages the spec checks
  # --------------------------------------------------------------------------
  def feed
    @user  = User.find(params[:id])
    @feed_photos =
      Photo.
        where(owner: @user.following.where(follow_requests: { status: "accepted" })).
        order(created_at: :desc)
  end

  def discover
    @user = User.find(params[:id])
    followed_user_ids =
      @user.following.where(follow_requests: { status: "accepted" }).pluck(:id)

    @discovery_photos =
      Photo.
        joins(:likes).
        where(likes: { fan_id: followed_user_ids }).
        distinct.
        order(created_at: :desc)
  end
end
