class FollowRequestsController < ApplicationController
  # POST /follow_requests
  def create
    request = current_user.sent_follow_requests.build(recipient_id: params[:recipient_id])

    request.status =
      if request.recipient.private?
        "pending"
      else
        "accepted"
      end

    if request.save
      msg = request.pending? ? "Follow request sent." : "You are now following #{request.recipient.username}."
      redirect_back fallback_location: users_path, notice: msg
    else
      redirect_back fallback_location: users_path, alert: request.errors.full_messages.to_sentence
    end
  end

  # PATCH /follow_requests/:id
  def update
    request = current_user.received_follow_requests.find(params[:id])

    if %w[accepted rejected].include?(params[:status])
      request.update(status: params[:status])
      redirect_back fallback_location: user_path(current_user), notice: "Follow request #{params[:status]}."
    else
      redirect_back fallback_location: user_path(current_user), alert: "Invalid status."
    end
  end

  # DELETE /follow_requests/:id
  def destroy
    request = FollowRequest.find(params[:id])

    if request.sender == current_user || request.recipient == current_user
      request.destroy
      redirect_back fallback_location: users_path, notice: "Relationship removed."
    else
      redirect_back fallback_location: root_path, alert: "Not authorized."
    end
  end
end
