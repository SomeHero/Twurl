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
        end
        get "" do
          Rails.logger.debug "Getting Twurls"

          offset = 0
          number_per_page = 20

          if params["page_number"] && params["page_number"].to_s.length > 0
            offset = number_per_page * (params["page_number"].to_i - 1)
          end

          if params["category_id"] && params["category_id"].to_s.length > 0
            twurls = TwurlLink.where(display: true, influencer_id: Influencer.select("id").where(channel_id: Channel.select("id").where(category_id: params["category_id"]))).order('created_at DESC').offset(offset).take(20)
          else
            twurls = TwurlLink.where(display: true).order('created_at DESC').offset(offset).take(20)
          end

          twurls
        end
      end
    end
  end
end
