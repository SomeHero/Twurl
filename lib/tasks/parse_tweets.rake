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

  url_exceptions = UrlException.pluck(:url)

  last_parse_audit = ParseTwurlsBatchAudit.last

  first_influencer_parsed_id = 0
  last_influencer_parsed_id = 0
  start_influencer_id = 1
  number_of_twurls_created = 0
  number_of_twurls_errors = 0
  rate_limited = false

  if last_parse_audit && last_parse_audit.last_influencer_parsed_id
    start_influencer_id = last_parse_audit.last_influencer_parsed_id + 1
  end
  users = Influencer.where("id >= ?", start_influencer_id).order("id asc")
  if users.count > 0
    first_influencer_parsed_id = users.first.id
  else
    start_influencer_id = 0
    users = Influencer.where("id >= ?", start_influencer_id).order("id asc")
  end

  # users.each do |user|
  #   break if rate_limited
  #
  #   begin
  #     twitter_user = client.user(user.handle)
  #     user.profile_image_url = twitter_user.profile_image_url.to_s
  #
  #     user.save!
  #   rescue Twitter::Error::TooManyRequests => error
  #     puts "we got an error: #{error}"
  #   rescue
  #     puts "Error #{$!}"
  #   end
  #
  #   begin
      tweets = client.home_timeline() #user_timeline("@twurl_app", { count: 200 })

      puts "we found #{tweets.count}"

      tweets.each do |tweet|

        user = Influencer.where(:twitter_username => tweet.user.screen_name).first

        if !user
          puts "we couldn't find an influencer #{tweet.user.screen_name}"
          next
        end

        twurl = TwurlLink.where(:twitter_id => tweet.id).first

        if(!twurl)
          urls = extract_urls(tweet.full_text)

          if(urls.count == 0)
            puts "this tweet is not a twurl"
          end

          if(urls.count > 0)

            #article = Diffbot::Article.fetch(urls.first) do |request|
            #  request.summary = true # Return a summary text instead of the full text.
            #end

            url = urls.first

            # call api with key (you'll need a real key)
            embedly_api = Embedly::API.new :key => 'f782cd992e754ce1b0ef53aff7628c46',
                    :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; james@somehero.com)'
            obj = embedly_api.extract :url => url
            article = obj[0]

            uri = URI.parse(article.provider_url)

            puts uri.host
            if url_exceptions.include? uri.host
              puts "this tweet is on the exclusing list #{uri.host}"
              next
            end

            headline_image_url = article.images[0]["url"]
            headline_image_width = article.images[0]["width"]
            headline_image_height = article.images[0]["height"]
            puts "we're creating a twurl"

            begin
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

              number_of_twurls_created += 1
              puts "we created #{number_of_twurls_created}"
            rescue
              puts "we got an error #{$!}"

              number_of_twurls_errors += 1
            end
          end
        end
    #   end
    # rescue Twitter::Error::TooManyRequests => error
    #   puts "we got rate limited #{error}"
    #
    #   rate_limited = true
    #   next
    # rescue
    #   puts "we got an error #{$!}"
    # end
    #
    # last_influencer_parsed_id = user.id
  end

  # if last_influencer_parsed_id != 0
  #   ParseTwurlsBatchAudit.create!({
  #     :twurls_created => number_of_twurls_created,
  #     :twurls_errors => number_of_twurls_errors,
  #     :first_influencer_parsed_id => first_influencer_parsed_id,
  #     :last_influencer_parsed_id => last_influencer_parsed_id
  #   })
  # end
end
