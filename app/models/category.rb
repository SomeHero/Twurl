class Category < ActiveRecord::Base
  has_many :channels, :dependent => :delete_all
  has_many :influencers, :through => :channels
end
