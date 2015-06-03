class AddTwitterUserNameToInfluencers < ActiveRecord::Migration
  def change
    add_column :influencers, :twitter_username, :string
  end
end
