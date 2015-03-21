class Readability
  def self.content_of_article(url:)
    root_path = File.expand_path("..", File.dirname(File.absolute_path(__FILE__)))
    bin_path = File.join(root_path, "bin")
    begin
      return `#{bin_path}/get_article_content.js #{url}`.chomp
    rescue
      return ""
    end
  end
end
