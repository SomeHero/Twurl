module API
  module V1
    class Feeds < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :feeds do
        desc "returns all feeds"

        get "" do
          Rails.logger.debug "Getting Feeds"

          Feed.order('feed_name ASC').all
        end

        desc "get twurls for a feed"
        params do
          optional :category_id, type: Integer, desc: "Optional Category"
          optional :page_number, type: Integer, desc: "Page Number"
          optional :last_twurl_id, type: Integer, desc: "The id of the last twurl returned from a previous request"
        end
        get "/:id/twurls" do
          Rails.logger.debug "Getting twurls for feed #{params["id"]}"

          offset = 0
          number_per_page = 20
          last_twurl_id = TwurlLink.maximum(:id) + 1

          feed = Feed.find(params[:id])

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

          Rails.logger.debug "#{twurls}"

          twurls
        end
      end
    end
  end
end
