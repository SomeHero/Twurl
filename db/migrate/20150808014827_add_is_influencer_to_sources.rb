class AddIsInfluencerToSources < ActiveRecord::Migration
  def change
    add_column :sources, :is_influencer, :boolean, :default => false
  end
end
