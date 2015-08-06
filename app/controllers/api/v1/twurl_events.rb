module API
  module V1
    class TwurlEvents < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :twurl_events do
        desc "add a twurl event"
        params do
          requires :twurl_id, type: Integer, desc: "the id of the twurl"
          requires :event_name, type: String, desc: "the name of the event (click, retwurl, mute)"
        end
        post "" do
          Rails.logger.debug "Creating a Twurl Event"

          TwurlEvent.create!({
              :twurl_link_id => params["twurl_id"],
              :twurl_event_name => params["event_name"]
          })

          return { success: true }
        end
      end
    end
  end
end
