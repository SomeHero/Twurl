class Feed < ActiveRecord::Base
  belongs_to :user
  has_many :feedorizations
  has_many :twurls, :through => :feedorizations
  has_and_belongs_to_many :twurls, class_name: "TwurlLink"

end
