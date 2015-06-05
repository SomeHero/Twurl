include Twitter::Extractor

desc "Parse Tweets from Users"
task :parse_tweets=> [:environment] do

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
  end

  Diffbot.configure do |config|
    config.token = ENV["DIFFBOT_TOKEN"]
  end

  users = Influencer.all

  users.each do |user|
    puts user.handle

    num_attempts = 0
    begin
      num_attempts += 1
      tweets = client.user_timeline(user.handle, { count: 10 })

      puts "we found #{tweets.count}"

      tweets.each do |tweet|

        twurl = TwurlLink.where(:twitter_id => tweet.id).first

        if(!twurl)
          urls = extract_urls(tweet.full_text)

          if(urls.count > 0)
            puts "we're creating a twurl"

            article = Diffbot::Article.fetch(urls.first) do |request|
              request.summary = true # Return a summary text instead of the full text.
            end

            headline_image_url = article.media.select { |m| m["type"] == "image" }.select { |m| m["primary"] == "true" }.first.link

            TwurlLink.create!({
              :twitter_id => tweet.id,
              :influencer => user,
              :headline => article.summary.truncate(255),
              :headline_image_url => headline_image_url,
              :url => article.resolved_url
            })
          end
        end
      end
    rescue Twitter::Error::TooManyRequests => error
      puts "we got an #{error}"

      if num_attempts % 3 == 0
        puts "sleeping"
        sleep(1*60) # minutes * 60 seconds
        retry
      else
        retry
      end
    rescue
      puts "we got an error #{$!}"
    end
  end
end
