class RemoveHashtagFromInfluencer < ActiveRecord::Migration
  def change
    remove_column :influencers, :hashtag
  end
end
