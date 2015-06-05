class AddTwitterIdToTwurls < ActiveRecord::Migration
  def change
    add_column :twurls, :twitter_id, :integer, :limit => 8
  end
end
