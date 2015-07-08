module API
  module V1
    class Categories < Grape::API
      version 'v1' # path-based versioning by default
      format :json # We don't like xml anymore

      resource :categories do
        desc "returns list of categories"

        get "" do
          Rails.logger.debug "Getting Categories"

          offset = 0

          Category.order('name ASC').all
        end
      end
    end
  end
end
