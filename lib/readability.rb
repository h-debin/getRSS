class Readability
  def self.content_of_article(url:)
    root_path = File.expand_path("..", File.dirname(File.absolute_path(__FILE__)))
    bin_path = File.join(root_path, "bin")
    `#{bin_path}/get_article_content.js #{url}`.chomp
  end
end
