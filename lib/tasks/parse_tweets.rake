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
  number_of_twurls_created = 0
  number_of_twurls_errors = 0
  rate_limited = false

  binding.pry

  if last_parse_audit && last_parse_audit.last_influencer_parsed_id
    last_influencer_parsed_id = last_parse_audit.last_influencer_parsed_id
  end

  users = Influencer.where("id > ?", last_influencer_parsed_id).order("id asc")

  first_influencer_parsed_id = users.first.id

  parse_twurls_batch_audit = ParseTwurlsBatchAudit.create!({
    :twurls_created => number_of_twurls_created,
    :twurls_errors => number_of_twurls_errors
  })

  users.each do |user|
    break if rate_limited

    begin
      twitter_user = client.user(user.handle)
      user.profile_image_url = twitter_user.profile_image_url.to_s

      user.save!
    rescue Twitter::Error::TooManyRequests => error
      puts "we got an error: #{error}"
    rescue
      puts "Error #{$!}"
    end

    binding.pry
    begin
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

            url = urls.first

            # call api with key (you'll need a real key)
            embedly_api = Embedly::API.new :key => 'f782cd992e754ce1b0ef53aff7628c46',
                    :user_agent => 'Mozilla/5.0 (compatible; mytestapp/1.0; james@somehero.com)'
            obj = embedly_api.extract :url => url
            article = obj[0]

            uri = URI.parse(article.provider_url)

            puts uri.host
            next if url_exceptions.include? uri.host

            headline_image_url = article.images[0]["url"]
            headline_image_width = article.images[0]["width"]
            headline_image_height = article.images[0]["height"]

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
            rescue
              puts "we got an error #{$!}"

              number_of_twurls_errors += 1
            end
          end
        end
      end
    rescue Twitter::Error::TooManyRequests => error
      puts "we got rate limited #{error}"

      parse_twurls_batch_audit.twurls_created = number_of_twurls_created
      parse_twurls_batch_audit.twurls_errors = number_of_twurls_errors
      parse_twurls_batch_audit.save!

      rate_limited = true
      next
    rescue
      puts "we got an error #{$!}"
    end

    if first_influencer_parsed_id == user.id
      parse_twurls_batch_audit.first_influencer_parsed_id = first_influencer_parsed_id
    end
    parse_twurls_batch_audit.last_influencer_parsed_id = user.id
    parse_twurls_batch_audit.twurls_created = number_of_twurls_created
    parse_twurls_batch_audit.twurls_errors = number_of_twurls_errors
    parse_twurls_batch_audit.save!
  end
end
