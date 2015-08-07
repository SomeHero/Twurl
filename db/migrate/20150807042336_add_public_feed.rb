class AddPublicFeed < ActiveRecord::Migration
  def change
    feed = Feed.create!(
      :feed_name => "Public Feed",
      :is_public => true
    )

    twurls = TwurlLink.all

    twurls.each do |twurl|
      feed.twurls << twurl
    end
  end
end
