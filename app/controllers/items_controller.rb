class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :plays, :edit, :update, :destroy]
  before_action :admin_only, :only => [:new, :create, :edit, :update, :destroy]

  include ApplicationHelper

  # GET /items
  # GET /items.json
  def index
    @items = Item.all.order('plays DESC').page params[:page]
    @featured = Item.where(:featured => true).order('created_at DESC')
  end

   def latest
        @items = Item.all.order('pub_date DESC').page params[:page]
        @featured = Item.where(:featured => true).order('created_at DESC')
    end

  def fresh

    @feeds = Feed.all

    @feeds.each do |feed|
      update_feed(feed)
    end

  end 

  def featured
    @items = Item.where(:featured => true).order('created_at DESC')
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  def plays

    @item.plays = @item.plays.to_i + 1
    @item.save

    respond_to do |format|
     if @item.save
       format.json { render :show, status: :ok, location: @item }
     else
       format.html { render action: 'new' }
       format.json { render json: @item.errors, status: :unprocessable_entity }
     end
   end

  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
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
    def set_item
      @item = Item.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:title, :featured, :plays, :description, :pub_date, :url, :link, :guid, :author, :description, :duration, :image, :slug, :feed_id)
    end
end
