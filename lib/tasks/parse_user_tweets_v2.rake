include Twitter::Extractor

require 'metainspector'

desc "Parse Tweets for Users"
task :parse_user_tweets_v2=> [:environment] do

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  end

  number_of_twurls_created = 0
  number_of_twurls_errors = 0
  url_exceptions = UrlException.pluck(:url)

  users = User.all

  users.each do |user|
    feed = user.feeds.first

    if !feed
      puts "we were unable to find a feed"
      next
    end

    client.access_token = user.twitter_auth_token
    client.access_token_secret = user.twitter_secret

    tweets = client.home_timeline() #user_timeline("@twurl_app", { count: 200 })

    puts "we found #{tweets.count}"

    tweets.each do |tweet|
      twurl = TwurlLink.where(:twitter_id => tweet.id).first

      if(!twurl)
        urls = extract_urls(tweet.full_text)

        if(urls.count == 0)
          puts "this tweet is not a twurl"
        end

        if(urls.count > 0)

          url = urls.first

          begin
            article = MetaInspector.new(url)
          rescue
            puts "Error extracting url: #{$!}"

            next
          end

          uri = URI.parse(article.url)

          puts uri.host
          if url_exceptions.include? uri.host
            puts "this tweet is on the exclusing list #{uri.host}"
            next
          end

          if !article.images
            "there were no images"
            next
          end

          begin
            headline_image_url = article.images.with_size[0][0]
            headline_image_width = article.images.with_size[0][1]
            headline_image_height = article.images.with_size[0][2]
          rescue
            puts "we've got an issue parsing the article"

            next
          end

          puts "we're creating a twurl"

          source = Source.where(:handle => "@#{tweet.user.screen_name}").first

          if !source
            source = Source.create!({
              :twitter_username => "@#{tweet.user.screen_name}",
              :handle => tweet.user.name,
              :profile_image_url => tweet.user.profile_image_url.to_s,
              :is_influencer => false
            })
          else
            source.profile_image_url = tweet.user.profile_image_url.to_s
            source.save!
          end

          begin
            twurl = TwurlLink.create!({
              :twitter_id => tweet.id,
              :original_tweet => tweet.full_text,
              :source => source,
              :headline => article.title,
              :headline_image_url => headline_image_url,
              :headline_image_width => headline_image_width,
              :headline_image_height => headline_image_height,
              :url => article.url,
              :display => true
            })

            feed.twurls << twurl

            number_of_twurls_created += 1
            puts "we created #{number_of_twurls_created}"
          rescue
            puts "we got an error #{$!}"

            number_of_twurls_errors += 1
          end
        end
      end
    end
  end
end
