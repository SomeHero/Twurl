include Twitter::Extractor

require 'metainspector'

desc "Parse Tweets from Users"
task :parse_tweets_v2=> [:environment] do

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
  end

  url_exceptions = UrlException.pluck(:url)

  first_influencer_parsed_id = 0
  last_influencer_parsed_id = 0
  start_influencer_id = 1
  number_of_twurls_created = 0
  number_of_twurls_errors = 0
  rate_limited = false

  feed = Feed.where(:is_public => true).first

  if !feed
    puts "we can't find a feed"
  end

  tweets = client.home_timeline() #user_timeline("@twurl_app", { count: 200 })

  puts "we found #{tweets.count}"

  tweets.each do |tweet|

    user = Source.where(:handle => "@#{tweet.user.screen_name}").first

    if !user
      puts "we couldn't find an influencer #{tweet.user.screen_name}"
      next
    end

    if user.profile_image_url != tweet.user.profile_image_url.to_s
      puts "updating Influencer profile image"

      user.profile_image_url = tweet.user.profile_image_url.to_s
      user.save!
    end

    twurl = TwurlLink.where(:twitter_id => tweet.id).first

    if(!twurl)
      urls = extract_urls(tweet.full_text)

      if(urls.count == 0)
        puts "this tweet is not a twurl"
      end

      if(urls.count > 0)

        url = urls.first

        article = MetaInspector.new(url)
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

          begin
            twurl = TwurlLink.create!({
              :twitter_id => tweet.id,
              :original_tweet => tweet.full_text,
              :source => user,
              :headline => article.title,
              :headline_image_url => headline_image_url,
              :headline_image_width => headline_image_width,
              :headline_image_height => headline_image_height,
              :url => article.url
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
