class Channel < ActiveRecord::Base
  belongs_to :category
  has_many :influencers
end
