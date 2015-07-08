class TwurlLink < ActiveRecord::Base
  self.table_name = "twurls"

  belongs_to :influencer

  def as_json(options={})
  {
    :id => self.id,
    :influencer => self.influencer,
    :headline_image_url => self.headline_image_url,
    :headline => self.headline,
    :description => self.description,
    :url => self.url,
    :share_count => self.share_count,
    :like_count => self.like_count,
    :headline_image_width => self.headline_image_width,
    :headline_image_height => self.headline_image_height,
    :created_at => self.created_at,
    :updated_at	=> self.updated_at
  }
  end
end
