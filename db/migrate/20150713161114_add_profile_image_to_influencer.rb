class AddProfileImageToInfluencer < ActiveRecord::Migration
  def change
    add_column :influencers, :profile_image_url, :string
  end
end
