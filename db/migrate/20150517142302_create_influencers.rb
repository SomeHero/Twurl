class CreateInfluencers < ActiveRecord::Migration
  def change
    create_table :influencers do |t|
      t.string :handle
      t.string :hashtag

      t.timestamps
    end
  end
end
