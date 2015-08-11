# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create!({:email => 'admin@twurl.net', :password => 'twurl424#'  })

feed = Feed.create!(
  :feed_name => "Public Feed",
  :is_public => true
)

twurls = TwurlLink.all

twurls.each do |twurl|
  feed.twurls << twurl
end

feed.save!
