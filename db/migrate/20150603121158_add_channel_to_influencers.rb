class AddChannelToInfluencers < ActiveRecord::Migration
  def change
    remove_column :influencers, :category_id
    add_column :influencers, :channel_id, :integer
  end
end
