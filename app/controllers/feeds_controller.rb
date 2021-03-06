class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, :only => [:new, :create, :edit, :update, :destroy]


  require 'rss'
  include ApplicationHelper

  # GET /feeds
  # GET /feeds.json
  def index
    @feeds = Feed.all.order('pub_date ASC')
  end

  def categories
    @categories = []

    @feeds =  Feed.all

   @feeds.each do |feed|

      if feed.try(:category)
        @categories << feed.category
      end
    end

    @categories = @categories.uniq

  end


  def category
    @category = params[:category]
    @feeds = Feed.all.where(:category => @category)

    @items = []

    @feeds.each do |feed|
      @items << feed.items[0]
    end

    @featured = Item.where(:featured => true).order('created_at DESC')

  end


  # GET /feeds/1
  # GET /feeds/1.json
  def show

    update_feed(@feed)

    @items = @feed.items.order('pub_date DESC').page params[:page]

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

  
    if @rss.channel.itunes_image != nil
      @feed.image = @rss.channel.itunes_image.href
    else @rss.channel.image != nil
      @feed.image = @rss.channel.image.url
    end 
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


  def admin_only
    unless current_user && current_user.admin?
      redirect_to root_path, :alert => "Access denied."
    end
  end
    # Use callbacks to share common setup or constraints between actions.
    def set_feed
      @feed = Feed.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:url, :image, :title, :link, :pub_date, :description, :author, :language, :keywords, :owner_name, :owner_email, :category, :user_id, :slug)
    end
end
