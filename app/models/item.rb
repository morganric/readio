class Item < ActiveRecord::Base


paginates_per 10


belongs_to :feed

end
