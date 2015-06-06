class Category < ActiveRecord::Base
  has_many :channels, :dependent => :delete_all
end
