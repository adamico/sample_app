class Micropost < ActiveRecord::Base
  belongs_to :user
  attr_accessible :content

  default_scope :order => 'microposts.created_at DESC'
end
