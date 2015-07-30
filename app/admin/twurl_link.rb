ActiveAdmin.register TwurlLink do

filter :headline
filter :url
filter :created_at
filter :display

permit_params :influencer_id, :headline_image_url, :headline_image_height, :headline_image_width,
  :headline, :description, :url, :twitter_id, :original_tweet, :display

index do
  column :id
  column "category" do |twurl|
    twurl.influencer.channel.category.name if twurl.influencer
  end
  column "channel" do |twurl|
    twurl.influencer.channel.name
  end
  column "source" do |twurl|
    twurl.influencer.handle
  end
  column :headline
  column "Image" do |twurl|
    image_tag twurl.headline_image_url, style: 'width: 320px;'
  end
  column :url
  column :created_at
  column :updated_at
  column :display
  actions
end

end
