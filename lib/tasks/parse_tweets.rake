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
    twitter_user = client.user(user.handle)
    user.profile_image_url = twitter_user.profile_image_url.to_s

    user.save!

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

            #article = Diffbot::Article.fetch(urls.first) do |request|
            #  request.summary = true # Return a summary text instead of the full text.
            #end

            # call api with key (you'll need a real key)
            embedly_api = Embedly::API.new :key => 'f782cd992e754ce1b0ef53aff7628c46',
                    :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; james@somehero.com)'
            obj = embedly_api.extract :url => urls.first
            article = obj[0]

            headline_image_url = article.images[0]["url"]
            headline_image_width = article.images[0]["width"]
            headline_image_height = article.images[0]["height"]

            TwurlLink.create!({
              :twitter_id => tweet.id,
              :original_tweet => tweet.full_text,
              :influencer => user,
              :headline => article.title,
              :headline_image_url => headline_image_url,
              :headline_image_width => headline_image_width,
              :headline_image_height => headline_image_height,
              :url => article["url"]
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
