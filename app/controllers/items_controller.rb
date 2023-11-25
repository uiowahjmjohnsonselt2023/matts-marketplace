class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ new create edit update destroy]

  # GET /items or /items.json
  def index
    @items = Item.all
    @items = @items.where(for_sale: true)
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    respond_to do |format|
      if @item.save
        format.html { redirect_to item_url(@item), notice: "Item was successfully created." }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to item_url(@item), notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1 or /items/1.json
  def destroy
    @item.destroy!

    respond_to do |format|
      format.html { redirect_to items_url, notice: "Item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def search
    # Read in the search term, category, and price_range from the params
    params = search_params
    if params[:search].empty? && params[:category].empty? && params[:price_range].empty?
      flash[:alert] = "Search terms included all items!"
      redirect_to items_path
    else
      # Categories into array so that we can switch to select multiple in future
      @items =  Item.search params[:search], [params[:category]], params[:price_range]
      if @items.empty?
        flash[:alert] = "No items found!"
        redirect_to items_path
      else
        flash[:notice] = "Found " + @items.length.to_s + " items!"
        render search_items_path
      end
    end
  end

  def simple_search
    # Read in the search term, category, and price_range from the params
    params = search_params
    if params[:search].empty?
      redirect_to items_path
    else
      # Categories into array so that we can switch to select multiple in future
      @items =  Item.search params[:search], nil, nil
      if @items.empty?
        flash[:alert] = "No items found!"
        redirect_to items_path
      else
        render search_items_path
      end
    end
  end

  def category_search
    # Read in the search term, category, and price_range from the params
    if params[:category].empty?
      redirect_to items_path
    else
      # Categories into array so that we can switch to select multiple in future
      @items =  Item.search nil, params[:category], nil
      if @items.empty?
        flash[:alert] = "No items found!"
        redirect_to items_path
      else
        render search_items_path
      end
    end
  end

  # app/controllers/items_controller.rb
  def toggle_wishlist
    item = Item.find(params[:item_id])
    if current_user.wishlist_items.include?(item)
      current_user.wishlist_items.delete(item)
    else
      current_user.wishlist_items << item
    end
    redirect_back(fallback_location: root_path)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_item
    @item = Item.find(params[:id])
  end

    # Only allow a list of trusted parameters through.
  def item_params
    params.require(:item).permit(:price, :description, :image_url, :category, :for_sale)
  end

  def search_params
    params.permit(:search, :category, :price_range)
  end
end
