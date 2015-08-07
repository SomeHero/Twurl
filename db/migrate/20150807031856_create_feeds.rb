class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :feed_name
      t.references :user, index: true
      t.boolean :is_public

      t.timestamps
    end
  end
end
