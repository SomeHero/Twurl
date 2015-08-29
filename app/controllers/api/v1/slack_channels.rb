module API
  module V1
    class SlackChannels < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :slack_channels do
        desc "adds a slack channel for the user"
        params do
          requires :user_id, type: Integer, desc: "The user's id"
          requires :team_name, type: String, desc: "the name of the slack team"
          requires :channel, type: String, desc: "the slack channel"
          requires :webhook_url, type: String, desc: "the slack webhook url"
          requires :access_token, type: String, desc: "scope of the slack oauth request"
        end
        post "" do
          Rails.logger.debug "Getting Slack Teams/Channels for #{params["id"]}"

          user = User.find(params["user_id"])

          #throw error if no user
          slack_team = SlackTeam.where(:team_name => params["team_name"]).first

          if(!slack_team)
              slack_team = SlackTeam.create!({
                  :user => user,
                  :team_name => params["team_name"]
              })
          end

          slack_channel = slack_team.slack_channels.where(:channel_name => params["channel"]).first

          if(!slack_channel)
              slack_channel = SlackChannel.create!({
                  :slack_team => slack_team,
                  :channel_name => params["channel"],
                  :webhook_url => params["webhook_url"],
                  #:access_token => params["access_token"],
                  #:configuration_url => params["configuration_url"]
              })
          end

          slack_channel
        end
      end
    end
  end
end
