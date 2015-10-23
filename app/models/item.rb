class Item < ActiveRecord::Base

paginates_per 10
belongs_to :feed

 extend FriendlyId
  friendly_id :title, use: :slugged

end
