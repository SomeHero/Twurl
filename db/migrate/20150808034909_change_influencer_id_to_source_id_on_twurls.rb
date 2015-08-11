class ChangeInfluencerIdToSourceIdOnTwurls < ActiveRecord::Migration
  def change
    rename_column :twurls, :influencer_id, :source_id
  end
end
