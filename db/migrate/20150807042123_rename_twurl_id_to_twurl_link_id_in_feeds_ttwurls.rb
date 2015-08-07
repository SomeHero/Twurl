class RenameTwurlIdToTwurlLinkIdInFeedsTtwurls < ActiveRecord::Migration
  def change
    rename_column :feeds_twurls, :twurl_id, :twurl_link_id
  end
end
