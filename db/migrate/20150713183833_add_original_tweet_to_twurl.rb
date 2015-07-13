class AddOriginalTweetToTwurl < ActiveRecord::Migration
  def change
    add_column :twurls, :original_tweet, :string
  end
end
