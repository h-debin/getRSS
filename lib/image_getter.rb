class ImageGetter
  require 'nokogiri'
  require 'open-uri'
  require 'fastimage'

  def self.on(url:)
    images = []
    begin
      doc = Nokogiri::HTML(open(url), nil, "UTF-8")
      doc.css("img").each do |img|
        images << img.attr("src")
      end
      doc.css("IMG").each do |img|
        images << img.attr("src")
      end
    rescue Exception => e
      puts "Exception: #{e.to_s}"
    end
    images
  end

  # ++
  # normally, the biggest size of image 
  # should be the featured image of a article
  # ++
  def self.largest(url:)
    images = on(url:url)
    max_size = 0
    max_image = nil;
    images.each do |img|
      size = FastImage.size(img)
      if size != nil && size.length == 2

        # ++
        # when a image's height (or width) is way large than width (height)
        # it should not be the feature image of a article 
        # ++
        rate = size[0] * 1.0 / size[1]
        if rate > 3 || rate < 0.333
          next
        end

        # ++
        # when the height or width of image is two small
        # it should not be the feature image of a article also
        # ++
        if size[0] < 20 || size[1] < 20
          next
        end

        size = size[0] * size[1]
        if size > max_size
          max_size = size
          max_image = img
        end
      end
    end
    max_image
  end
end
