class Feedorization < ActiveRecord::Base
  belongs_to :twurl
  belongs_to :feed
end
