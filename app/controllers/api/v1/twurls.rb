module API
  module V1
    class Twurls < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :twurls do
        desc "returns list of supported banks"

        get "" do
          Rails.logger.debug "Getting Twurls"

          offset = 0
          
          TwurlLink.order('created_at DESC').offset(offset).take(20)
        end
      end
    end
  end
end
