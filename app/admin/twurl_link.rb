ActiveAdmin.register TwurlLink do

filter :headline
filter :url
filter :created_at
filter :display

permit_params :source_id, :headline_image_url, :headline_image_height, :headline_image_width,
  :headline, :description, :url, :twitter_id, :original_tweet, :display

index do
  column :id
  column "category" do |twurl|
    twurl.source.channel.category.name if twurl.source && twurl.source.channel && twurl.source.channel.category
  end
  column "channel" do |twurl|
    twurl.source.channel.name if twurl.source && twurl.source.channel
  end
  column "source" do |twurl|
    twurl.source.handle if twurl.source
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

form do |f|
  f.inputs "Twurl Details" do
    f.input :id, :as => :string, :input_html => { :readonly => true }
    f.input :source, :collection => Source.where(:id => f.object.source).pluck(:handle, :id), :include_blank => false
    f.input :headline, :as => :text, :input_html => { :class => 'autogrow', :rows => 4 }
    f.input :headline_image_url, :as => :url
    f.input :description, :as => :text, :input_html => { :class => 'autogrow', :rows => 6 }
    f.input :original_tweet, :as => :text, :input_html => { :class => 'autogrow', :rows => 4 }
    f.input :url, :as => :url
    f.input :display
    f.input :created_at, :as => :string, :input_html => { :readonly => true }
    f.input :updated_at, :as => :string, :input_html => { :readonly => true }
  end
  f.actions
end

end
