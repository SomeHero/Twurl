module API
  module V1
    class ReadingList < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :reading_list do
        desc "adds to a user's reading list"
        params do
          requires :user_id, type: String, desc: "the user's id"
        end
        post "/:id" do
          Rails.logger.debug "Muting a twurl source"

          user = User.find(params["user_id"])
          twurl = TwurlLink.find(params["id"])

          UserReadingList.create!({
              :user => user,
              :twurl_link => twurl
          })

          return { success: true }
        end

        desc "un-mutes a source"
        params do
          requires :user_id, type: String, desc: "the user's id"
        end
        delete "/:id" do
          Rails.logger.debug "Remove a twurl from the user's reading list"

          user = User.find(params["user_id"])
          twurl = TwurlLink.find(params["id"])

          UserReadingList.where(:user => user, :twurl_link => twurl).destroy_all

          return { success: true }
        end
      end
    end
  end
end
