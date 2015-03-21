class String
  def only_letters
    str = ''
    self.chars.each do |c|
      if c.ord >= 0 && c.ord <= 64
      elsif c.ord >= 91 && c.ord <= 96
      elsif c.ord >= 123 && c.ord <= 127
      else
        str += c
      end
    end
    str
  end
end

# ++
# build on top of RMMSeg (http://rmmseg.rubyforge.org/)
# ++
class Tokenizer
  def self.tokenize(text:)
    raise "Exception: no text given to Tokenizer" if text == nil
    
    clone = text.to_s.only_letters
    begin
      return `echo #{clone} | rmmseg`.force_encoding('UTF-8').split(' ')
    rescue
      return "" 
    end
  end
end
