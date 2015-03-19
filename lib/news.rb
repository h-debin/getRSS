class News < ActiveRecord::Base
  validates :title, presence: true
  validates :title, uniqueness: true
  validates :pub_date, presence: true
  validates :link, presence: true
end
