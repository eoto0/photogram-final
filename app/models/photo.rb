# == Schema Information
#
# Table name: photos
#
#  id             :bigint           not null, primary key
#  caption        :text
#  comments_count :integer
#  image          :string
#  likes_count    :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  owner_id       :integer
#
# Indexes
#
#  index_photos_on_owner_id  (owner_id)
#
class Photo < ApplicationRecord
  belongs_to :owner, class_name: "User", counter_cache: true

  # has_one_attached :image
  validates :image, presence: true

  has_many :comments, dependent: :destroy
  has_many :likes,    dependent: :destroy
  has_many :fans, through: :likes, source: :fan
end
