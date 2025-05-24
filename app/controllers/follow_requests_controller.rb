class FollowRequestsController < ApplicationController
  # POST /follow_requests
  def create
    recipient = User.find(params[:recipient_id])

    request = current_user.sent_follow_requests.
                find_or_initialize_by(recipient: recipient)

    request.status =
      recipient.private? ? "pending" : "accepted"

    if request.save
      msg = request.pending? ? "Request sent." : "Now following!"
      redirect_back fallback_location: user_path(recipient), notice: msg
    else
      redirect_back fallback_location: user_path(recipient),
                    alert: request.errors.full_messages.to_sentence
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
    fr = FollowRequest.find(params[:id])

    if fr.sender == current_user || fr.recipient == current_user
      fr.destroy
      redirect_back fallback_location: user_path(current_user),
                    alert: "Follow request canceled."
    else
      redirect_back fallback_location: root_path,
                    alert: "Not authorized."
    end
  end
end
