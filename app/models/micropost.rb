# == Schema Information
# Schema version: 20100917115459
#
# Table name: microposts
#
#  id         :integer         not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime


class Micropost < ActiveRecord::Base
  attr_accessible :content

  belongs_to :user

  validates :user_id , :presence => true
  validates :content, :presence => true, :length => { :maximum => 140}

  default_scope :order => 'microposts.created_at DESC'

  scope :from_users_followed_by, lambda { |user| followed_by(user) }

  private

  def self.followed_by(user)
    followed_ids = user.following_ids.join(", ")
    where("user_id = :user_id OR user_id IN (#{followed_ids})",
          { :user_id => user})
  end
end
