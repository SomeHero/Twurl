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
        end
        get "" do
          Rails.logger.debug "Getting Twurls"

          offset = 0
          number_per_page = 20
          last_twurl_id = TwurlLink.maximum(:id) + 1

          if params["page_number"] && params["page_number"].to_s.length > 0
            offset = number_per_page * (params["page_number"].to_i - 1)
          end
          if params["last_twurl_id"] && params["last_twurl_id"].to_s.length > 0
            last_twurl_id = params["last_twurl_id"].to_i
          end
          if params["category_id"] && params["category_id"].to_s.length > 0
            twurls = TwurlLink.where("display = ? AND id < ? AND influencer_id IN (?)", true, last_twurl_id, Influencer.select("id").where(channel_id: Channel.select("id").where(category_id: params["category_id"]))).order('id DESC').offset(offset).take(20)
          else
            twurls = TwurlLink.where("display = ? AND id < ?", true, last_twurl_id).order('id DESC').offset(offset).take(20)
          end

          twurls
        end
      end
    end
  end
end
