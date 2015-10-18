json.array!(@items) do |item|
  json.extract! item, :id, :title, :description, :pub_date, :url, :link, :guid, :author, :description, :duration, :image, :slug, :feed_id
  json.url item_url(item, format: :json)
end
