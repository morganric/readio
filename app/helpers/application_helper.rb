module ApplicationHelper


	def update_feed(feed)


    @items = RSS::Parser.parse(open(feed.url).read, false).items
    @fresh = []

    @items.each do |item|

        if Date.parse(item.pubDate.strftime("%Y-%m-%d %I:%M%P")) > Date.parse(@items.first.pubDate.strftime("%Y-%m-%d %I:%M%P")) ||  feed.items == []
          i = Item.new
          i.title = item.title
          i.description = item.description
          i.pub_date = item.pubDate
          i.link = item.link
          i.title = item.title
          i.url = item.enclosure.url
          i.guid = item.guid
          i.author = item.author
          i.plays = rand(1..10)
          i.feed_id = @feed.id

          i.save
          @fresh << i
          end

      end

	end

end
