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
    req   = current_user.received_follow_requests.find(params[:id])
    action = params[:accept] == "true" ? "accepted" : "rejected"
    req.update(status: action)

    redirect_back fallback_location: user_path(current_user),
                  notice: "Follow request #{action}."
  end

  # DELETE /follow_requests/:id
 def destroy
    request = current_user.sent_follow_requests.find(params[:id])
    request.destroy
    redirect_back fallback_location: users_path, notice: "Relationship removed."
  end
end
