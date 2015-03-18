class News < ActiveRecord::Base
  validates :title, presence: true
  validates :pub_date, presence: true
  validates :link, presence: true
end
