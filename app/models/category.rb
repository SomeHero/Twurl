class Category < ActiveRecord::Base
  has_many :channels
end
