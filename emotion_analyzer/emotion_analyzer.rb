class EmotionAnalyzer
  require 'open-uri'
  require 'json'
  require 'redis'

  CATEGORY_MAP = {
    'PA' => '乐',
    'PE' => '乐',
    'PD' => '好',
    'PH' => '好',
    'PG' => '好',
    'PB' => '好',
    'PK' => '好',
    'NA' => '怒',
    'NB' => '哀',
    'NJ' => '哀',
    'NH' => '哀',
    'PE' => '哀',
    'NI' => '惧',
    'NC' => '惧',
    'NG' => '惧',
    'NE' => '恶',
    'ND' => '恶',
    'NN' => '恶',
    'NK' => '恶',
    'NL' => '恶',
    'PC' => '惊',
  }

  TYPE = {
    '0' => '中性',
    '1' => '正面',
    '2' => '负面',
  }

  def self.on(word:nil, text:nil, file:nil, url:nil)
    if word
      analyze_on_word(word)
    elsif text
      analyze_on_text(text)
    elsif file
      analyze_on_file(file)
    elsif url
     analyze_on_url(url)
    end
  end
 
  private
  def self.analyze_on_word(word)
    redis = Redis.new(:port => '4568')
    ret_hash = to_hash(string: redis.get(word))
    if ret_hash
      { 
        :category => CATEGORY_MAP[ret_hash["emotion_category"]],
        :level => ret_hash["emotion_level"],
        :type =>  TYPE[ret_hash["emotion_polarity"]],
        :word => word,
      }
    end
  end

  def self.analyze_on_text(text)
    words_emotion = []
    Tokenizer.tokenize(text:text).each do |word|
      words_emotion << analyze_on_word(word)
    end
    final_judge(words_emotion.compact)
  end

  def self.analyze_on_file(file)
    analyze_on_text(File.read(file))
  end

  def self.analyze_on_url(url)
    text = Readability.content_of_article(url:url)
    analyze_on_text(text)
  end

  def self.final_judge(emotion_words)
    emotion_category = {}
    emotion_words.each do |word|
      if emotion_category[word[:category]]
        emotion_category[word[:category]] += word[:level].to_i
      else
        emotion_category[word[:category]] = word[:level].to_i
      end
    end
    emotion_categorys = []
    emotion_category.each_pair do |k, v|
      tmp = {}
      tmp["key"] = k
      tmp["value"] = v
      emotion_categorys <<  tmp
    end
    quick_sort(emotion_categorys)
  end

  def self.quick_sort(elements)
    return elements if elements.length < 2
    left, right = elements[1..-1].partition do |ele|
      ele["value"] >= elements.first["value"]
    end
    quick_sort(left) + [elements.first] + quick_sort(right)
  end

  def self.to_hash(string:)
    JSON.parse(string.gsub("'",'"').gsub('=>',':')) if string
  end 
end
