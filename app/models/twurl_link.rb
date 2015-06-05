class TwurlLink < ActiveRecord::Base
  self.table_name = "twurls"

  belongs_to :influencer
end
