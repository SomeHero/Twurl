include Twitter::Extractor

desc "Parse Tweets for Users"
task :parse_user_tweets=> [:environment] do

  client = Twitter::REST::Client.new do |config|
    config.consumer_key = ENV['TWITTER_CONSUMER_KEY']
    config.consumer_secret = ENV['TWITTER_CONSUMER_SECRET']
  end

  Diffbot.configure do |config|
    config.token = ENV["DIFFBOT_TOKEN"]
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

            if !article.images
              "there were no images"
              next
            end

            begin
              headline_image_url = article.images[0]["url"]
              headline_image_width = article.images[0]["width"]
              headline_image_height = article.images[0]["height"]
            rescue
              puts "we've got an issue parsing the article"

              next
            end

            puts "we're creating a twurl"

            begin
              twurl = TwurlLink.create!({
                :twitter_id => tweet.id,
                :original_tweet => tweet.full_text,
                :headline => article.title,
                :headline_image_url => headline_image_url,
                :headline_image_width => headline_image_width,
                :headline_image_height => headline_image_height,
                :url => article["url"]
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

  # if last_influencer_parsed_id != 0
  #   ParseTwurlsBatchAudit.create!({
  #     :twurls_created => number_of_twurls_created,
  #     :twurls_errors => number_of_twurls_errors,
  #     :first_influencer_parsed_id => first_influencer_parsed_id,
  #     :last_influencer_parsed_id => last_influencer_parsed_id
  #   })
  # end
end
