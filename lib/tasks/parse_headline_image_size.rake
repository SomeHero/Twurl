require 'fastimage'

desc "Pull the size of headline images"
task :parse_headline_image_size => [:environment] do
  twurls = TwurlLink.order('created_at DESC').all

  twurls.each do |twurl|
    image_size = FastImage.size(twurl.headline_image_url)
    if image_size
      twurl.headline_image_width = image_size[0]
      twurl.headline_image_height = image_size[1]

      twurl.save
    end
  end
end
