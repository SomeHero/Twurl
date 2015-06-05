ActiveAdmin.register Twurls::Twurl do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if resource.something?
#   permitted
# end
index do
  column :id
  column "category" do |twurl|
    twurl.influencer.channel.category.name
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
  actions
end

end
