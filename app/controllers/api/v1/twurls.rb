require 'slack/post'

module API
  module V1
    class Twurls < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :twurls do
        desc "returns all twurls"
        params do
          optional :category_id, type: Integer, desc: "Optional Category"
          optional :page_number, type: Integer, desc: "Page Number"
          optional :last_twurl_id, type: Integer, desc: "The id of the last twurl returned from a previous request"
          optional :user_id, type: Integer, desc: "The user's id"
        end
        get "" do
          Rails.logger.debug "Getting Twurls"

          offset = 0
          number_per_page = 20
          last_twurl_id = TwurlLink.maximum(:id) + 1

          feed = Feed.where(:is_public => true).first

          return [] if !feed

          if params["page_number"] && params["page_number"].to_s.length > 0
            offset = number_per_page * (params["page_number"].to_i - 1)
          end
          if params["last_twurl_id"] && params["last_twurl_id"].to_s.length > 0
            last_twurl_id = params["last_twurl_id"].to_i
          end
          if params["category_id"] && params["category_id"].to_s.length > 0
            twurls = feed.twurls.where("display = ? AND id < ? AND source_id IN (?) and source_id NOT IN (?)", true, last_twurl_id, Source.select("id").where(channel_id: Channel.select("id").where(category_id: params["category_id"])), UserMutedSource.select("source_id").where(user_id: params["user_id"])).order('id DESC').offset(offset).take(number_per_page)
          else
            twurls = feed.twurls.where("display = ? AND id < ? AND source_id NOT IN (?)", true, last_twurl_id, UserMutedSource.select("source_id").where(user_id: params["user_id"])).order('id DESC').offset(offset).take(number_per_page)
          end

          twurls
        end

        desc "posts to a slack channel"
        params do
          requires :user_id, type: Integer, desc: "the id of the user"
          requires :slack_channel_id, type: Integer, desc: "the id of the slack channel to post to"
        end
        post "/:twurl_id/slackit" do
          Rails.logger.debug "posting to slack"

          user = User.find(params["user_id"])

          #return error if not user

          twurl = TwurlLink.find(params["twurl_id"])

          #return error if not twurl

          slack_channel = SlackChannel.find(params["slack_channel_id"])

          #return error slack_channel or if slack_channel is not owned by user

          #slackit
          Slack::Post.configure(
            webhook_url: slack_channel.webhook_url,
            username: 'James R'
          )

          message = "<" + twurl.url + ">"
          Slack::Post.post message, '#general'
        end
      end
    end
  end
end
