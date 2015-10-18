class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  require 'rss'

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.all
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show


    @items = RSS::Parser.parse(open(@feed.url).read, false).items

    @items.each do |item|

        if Date.parse(item.pubDate.strftime("%Y-%m-%d %I:%M%P")) > Date.parse(@items.last.pubDate.strftime("%Y-%m-%d %I:%M%P"))

          i = Item.new
          i.title = item.title
          i.description = item.description
          i.pub_date = item.pubDate
          i.link = item.link
          i.title = item.title
          i.url = item.enclosure.url
          i.guid = item.guid
          i.author = item.author
          
          i.feed_id = @feed.id

          i.save

          end

      end

  end

  # GET /feeds/new
  def new
    @feed = Feed.new
  end

  # GET /feeds/1/edit
  def edit
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(feed_params)



    @rss = RSS::Parser.parse(open(feed_params[:url]).read, false)

    @feed.title = @rss.channel.title
    @feed.link = @rss.channel.link
    @feed.pub_date = @rss.channel.pubDate
    @feed.description = @rss.channel.description
    @feed.author = @rss.channel.itunes_author
    @feed.language = @rss.channel.language
    @feed.image = @rss.channel.image.url
    # @feed.keywords = @rss.channel.keywords
    unless @rss.channel.itunes_owner.blank?
    @feed.owner_name = @rss.channel.itunes_owner.itunes_name
    @feed.owner_email = @rss.channel.itunes_owner.itunes_email
    end
    unless @rss.channel.itunes_category.blank?
    @feed.category = @rss.channel.itunes_category.text
    end
    @feed.user_id = current_user.id


    respond_to do |format|
      if @feed.save
        format.html { redirect_to @feed, notice: 'Feed was successfully created.' }
        format.json { render :show, status: :created, location: @feed }
      else
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /feeds/1
  # PATCH/PUT /feeds/1.json
  def update
    respond_to do |format|
      if @feed.update(feed_params)
        format.html { redirect_to @feed, notice: 'Feed was successfully updated.' }
        format.json { render :show, status: :ok, location: @feed }
      else
        format.html { render :edit }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to feeds_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:url, :image, :title, :link, :pub_date, :description, :author, :language, :keywords, :owner_name, :owner_email, :category, :user_id, :slug)
    end
end
