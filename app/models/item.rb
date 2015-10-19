class Item < ActiveRecord::Base


paginates_per 20


belongs_to :feed

end
