class ImageGetter
  require 'nokogiri'
  require 'open-uri'
  require 'fastimage'

  def self.on(url:)
    images = []
    doc = Nokogiri::HTML(open(url))
    doc.css("img").each do |img|
      images << img.attr("src")
    end
    doc.css("IMG").each do |img|
      images << img.attr("src")
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
    max_image = images[0]
    images.each do |img|
      size = FastImage.size(img)
      if size != nil && size.length == 2
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
