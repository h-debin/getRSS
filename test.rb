require 'cjk_helper'

  class String
    def only_letters
      str = ''
      self.chars.each do |c|
        if CJKHelper.is_cjk(c)
          str += c
        elsif c.ord >= 97 && c.ord <= 122
          str += c
        elsif c.ord >= 65 && c.ord <= 90
          str += c
        end
      end
      str
    end
  end
class A

  def echo
    a = "niaho , 我也是 fdfd><fdsfd "
    puts a.only_letters
  end
end

A.new.echo
