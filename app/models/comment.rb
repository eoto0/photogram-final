# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  author_id  :integer
#  photo_id   :integer
#
# Indexes
#
#  index_comments_on_author_id  (author_id)
#  index_comments_on_photo_id   (photo_id)
#
class Comment < ApplicationRecord
  belongs_to :photo,  counter_cache: true
  belongs_to :author, class_name: "User", counter_cache: :comments_count
  validates  :body,   presence: true
end
