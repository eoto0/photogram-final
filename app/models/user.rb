# == Schema Information
#
# Table name: users
#
#  id                             :bigint           not null, primary key
#  comments_count                 :integer
#  email                          :string           default(""), not null
#  encrypted_password             :string           default(""), not null
#  likes_count                    :integer
#  photos_count                   :integer
#  private                        :boolean
#  received_follow_requests_count :integer
#  remember_created_at            :datetime
#  reset_password_sent_at         :datetime
#  reset_password_token           :string
#  sent_follow_requests_count     :integer
#  username                       :string
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  def to_param
  username
end

  has_many :photos,       foreign_key: "owner_id", dependent: :destroy
  has_many :comments,     foreign_key: "author_id", dependent: :destroy
  has_many :likes,        foreign_key: "fan_id",    dependent: :destroy
  has_many :liked_photos, through: :likes, source:  :photo

  has_many :sent_follow_requests,
           class_name:  "FollowRequest",
           foreign_key: "sender_id", dependent: :destroy
  has_many :received_follow_requests,
           class_name:  "FollowRequest",
           foreign_key: "recipient_id", dependent: :destroy

  has_many :followers,
           -> { where(follow_requests: { status: "accepted" }) },
           through: :received_follow_requests, source: :sender
  has_many :followees,
           -> { where(follow_requests: { status: "accepted" }) },
           through: :sent_follow_requests, source: :recipient

end
