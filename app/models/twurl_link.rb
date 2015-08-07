class TwurlLink < ActiveRecord::Base
  self.table_name = "twurls"

  belongs_to :influencer
  has_many :feedorizations
  has_many :feeds, :through => :feedorizations
  has_and_belongs_to_many :feeds

  def as_json(options={})
  {
    :id => self.id,
    :influencer => self.influencer,
    :headline_image_url => self.headline_image_url,
    :headline => self.headline,
    :description => self.description,
    :original_tweet => self.original_tweet,
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
