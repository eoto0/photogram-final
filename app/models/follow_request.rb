# == Schema Information
#
# Table name: follow_requests
#
#  id           :bigint           not null, primary key
#  status       :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recipient_id :integer
#  sender_id    :integer
#
# Indexes
#
#  index_follow_requests_on_recipient_id  (recipient_id)
#  index_follow_requests_on_sender_id     (sender_id)
#
class FollowRequest < ApplicationRecord
    STATUSES = %w[pending accepted rejected]
  validates :status, inclusion: { in: STATUSES }
  validates :recipient_id, uniqueness: { scope: :sender_id }

  belongs_to :sender,    class_name: "User",
                         counter_cache: :sent_follow_requests_count
  belongs_to :recipient, class_name: "User",
                         counter_cache: :received_follow_requests_count
end
