module API
  module V1
    class Users < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :users do
        desc "adds or updates a user"
        params do
          requires :twitter_id, type: String, desc: "the user's twitter user id"
          requires :twitter_username, type: String, desc: "the user's twitter username"
          requires :twitter_auth_token, type: String, desc: "the auth token for the twitter account"
          requires :twitter_secret, type: String, desc: "the secret for the twitter account"
          optional :first_name, type: String, desc: "the first name of the user"
          optional :last_name, type: String, desc: "the last name of the user"
          optional :email_address, type: String, desc: "the email address of the user"
        end
        post "" do
          Rails.logger.debug "Creating a Twurl User"

          user = User.where(:twitter_id => params["twitter_id"]).first

          if !user
            user = User.create!({
                :twitter_id => params["twitter_id"],
                :twitter_username => params["twitter_username"],
                :twitter_auth_token => params["twitter_auth_token"],
                :twitter_secret => params["twitter_secret"],
                :first_name => params["first_name"],
                :last_name => params["last_name"],
                :email_address => params["email_address"]
            })

            feed = Feed.create!({
              feed_name: "Twurl Feed #{user.id.to_s}",
              user: user,
              is_public: false
            })
          else
            user.twitter_auth_token = params["twitter_auth_token"]
            user.twitter_secret = params["twitter_secret"]
            user.first_name = params["first_name"]
            user.last_name = params["last_name"]
            user.email_address = params["email_address"]

            user.save!
          end

          user
        end

        desc "returns a user"
        get "/:id" do
          Rails.logger.debug "Getting User #{params["id"]}"

          user = User.find(params["id"])

          user
        end

        desc "returns all twurls in the users private feed"
        get "/:id/feeds" do
          Rails.logger.debug "Getting Twurls for User #{params["id"]}"

          user = User.find(params["id"])

          offset = 0
          number_per_page = 20
          last_twurl_id = TwurlLink.maximum(:id) + 1

          feed = user.feeds.first

          if params["page_number"] && params["page_number"].to_s.length > 0
            offset = number_per_page * (params["page_number"].to_i - 1)
          end
          if params["last_twurl_id"] && params["last_twurl_id"].to_s.length > 0
            last_twurl_id = params["last_twurl_id"].to_i
          end
          if params["category_id"] && params["category_id"].to_s.length > 0
            twurls = feed.twurls.where("display = ? AND id < ? AND source_id IN (?) and source_id NOT IN (??)", true, last_twurl_id, Influencer.select("id").where(channel_id: Channel.select("id").where(category_id: params["category_id"])), UserMutedSource.select("source_id").where(user_id: params["id"])).order('id DESC').offset(offset).take(20)
          else
            twurls = feed.twurls.where("display = ? AND id < ? AND source_id NOT IN (?)", true, last_twurl_id, UserMutedSource.select("source_id").where(user_id: params["id"])).order('id DESC').offset(offset).take(20)
          end

          twurls
        end
      end
    end
  end
end
