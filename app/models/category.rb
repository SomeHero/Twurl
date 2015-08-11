class Category < ActiveRecord::Base
  has_many :channels, :dependent => :delete_all
  has_many :sources, :through => :channels
end
