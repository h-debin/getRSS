require 'pismo'

# Load a Web page (you could pass an IO object or a string with existing HTML data along, as you prefer)
doc = Pismo::Document.new('http://news.163.com/15/0311/23/AKFB8JND0001124J.html')
puts doc.sentences

