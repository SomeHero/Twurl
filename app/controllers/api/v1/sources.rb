module API
  module V1
    class Sources < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :sources do
        desc "mutes a source"
        params do
          requires :user_id, type: String, desc: "the user's id"
        end
        post "/:id/mute" do
          Rails.logger.debug "Muting a twurl source"

          user = User.find(params["user_id"])
          source = Source.find(params["id"])

          UserMutedSource.create!({
              :user => user,
              :source => source
          })

          return { success: true }
        end

        desc "un-mutes a source"
        params do
          requires :user_id, type: String, desc: "the user's id"
        end
        post "/:id/unmute" do
          Rails.logger.debug "Muting a twurl source"

          user = User.find(params["user_id"])
          source = Source.find(params["id"])

          UserMutedSource.where(:user => user, :source => source).destroy_all

          return { success: true }
        end
      end
    end
  end
end
