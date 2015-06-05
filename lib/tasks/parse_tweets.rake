include Twitter::Extractor

desc "Parse Tweets from Users"
task :parse_tweets=> [:environment] do

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
    config.access_token = ENV['TWITTER_ACCESS_TOKEN']
    config.access_token_secret = ENV['TWITTER_ACCESS_SECRET']
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

        twurl = Twurls::Twurl.where(:twitter_id => tweet.id).first

        if(!twurl)
          urls = extract_urls(tweet.full_text)

          if(urls.count > 0)
            puts "we're creating a twurl"

            Twurls::Twurl.create!({
              :twitter_id => tweet.id,
              :influencer => user,
              :headline => tweet.full_text,
              :url => urls.first
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
