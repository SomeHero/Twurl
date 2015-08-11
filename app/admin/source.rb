ActiveAdmin.register Source do
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
permit_params :handle, :twitter_username, :channel_id, :profile_image_url, :is_influencer

filter :channel
filter :handle
filter :twitter_username
filter :is_influencer

index do
  column :id
  column "Category" do |source|
    source.channel.category.name if source.channel && source.channel.category
  end
  column :channel
  column :twitter_username
  column :handle
  column :is_influencer
  column :created_at
  column :updated_at
  actions
end

end
