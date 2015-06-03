class CreateTwurls < ActiveRecord::Migration
  def change
    create_table :twurls do |t|
      t.references :influencer, index: true
      t.string :headline_image_url
      t.string :headline
      t.string :description
      t.string :url
      t.integer :share_count
      t.integer :like_count

      t.timestamps
    end
  end
end
