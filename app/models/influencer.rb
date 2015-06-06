class Influencer < ActiveRecord::Base
  belongs_to :channel
  has_many :twurl_links, :dependent => :delete_all
end
