json.array!(@feeds) do |feed|
  json.extract! feed, :id, :url, :title, :link, :pub_date, :description, :author, :language, :keywords, :owner_name, :owner_email, :category, :user_id, :slug
  json.url feed_url(feed, format: :json)
end
