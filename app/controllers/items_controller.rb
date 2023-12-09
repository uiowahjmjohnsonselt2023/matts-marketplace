class ItemsController < ApplicationController
  before_action :set_item, only: %i[ show edit update destroy admin_edit admin_update ]
  before_action :authenticate_user!, only: %i[ new create edit update destroy]
  before_action :require_admin, only: %i[ admin_edit admin_update ]

  # GET /items or /items.json
  def index
    redirect_to buyers_path
  end

  # GET /items/1 or /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
    @item.attributes = session.delete(:item_params) if session[:item_params].present?
  end

  # GET /items/1/edit
  def edit
    @item = Item.find(params[:id])
    if @item.nil? || @item.user_id != current_user.id
      redirect_to root_path
    end
    if @item.sold
      flash[:alert] = "You cannot edit an item that has been sold!"
      redirect_to items_path
    end
  end

  def admin_edit
  end

  # POST /items or /items.json
  def create
    @item = Item.new(item_params)
    @item.user_id = current_user.id

    if @item.save
      redirect_to sellers_path, notice: 'Item is on the market.'
    else
      session[:item_params] = item_params.to_h
      flash[:alert] = display_alert(@item)
      redirect_to new_item_path
    end
  end

  def display_alert(item)
    if item.errors[:price].any?
      'Price must be a number greater than 0.'
    elsif item.featured && item.featured_amount_paid.nil?
      'Enter feature amount if you want to feature your item.'
    elsif item.errors[:featured_amount_paid].any?
      'Feature amount must be a number greater than 0.'
    else
      'Description or Category field is required.'
    end
  end

  # PATCH/PUT /items/1 or /items/1.json
  def update
    @item = Item.find(params[:id])
    if @item.sold
      flash[:alert] = "You cannot edit an item that has been sold!"
      redirect_to items_path
    end
    if @item.user_id != current_user.id
      flash[:alert] = "You cannot edit an item that you do not own!"
      redirect_to items_path
    end

    if @item.update(item_params)
      redirect_to sellers_path, notice: 'Item was successfully updated.'
    else
      if @item.errors[:price].any?
        flash[:alert] = 'Price must be a number greater than 0.'
      else
        flash[:alert] = 'Description or Category field is required'
      end
      redirect_to edit_item_path
    end
  end

  def admin_update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to admin_manage_items_url, notice: "Item was successfully updated." }
        format.json { render :show, status: :ok, location: @item }
      else
        flash[:alert] = 'Item update failed. Please check each field.'
        format.html { render :admin_edit, status: :unprocessable_entity  }
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
    search = search_params
    if search[:search].empty? && search[:category].empty? && search[:price_range].empty?
      flash[:alert] = "Search terms included all items!"
      redirect_to items_path
    else
      # Categories into array so that we can switch to select multiple in future
      @items =  Item.search search[:search], [search[:category]], search[:price_range]
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
    search = search_params
    if search[:search].empty?
      redirect_to items_path
    else
      # Categories into array so that we can switch to select multiple in future
      @items =  Item.search search[:search], nil, nil
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

  def search_by_user
    # Searches for items sold by a given user.
    if params[:user_id].empty?
      redirect_to items_path
    else
      # Categories into array so that we can switch to select multiple in future
      @items =  Item.where(user: User.find(params[:user_id].to_i), for_sale: true)
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
    if current_user.nil?
      flash[:alert] = "You must be logged in to add items to your wishlist!"
    elsif current_user == item.user
      flash[:alert] = "You cannot add your own items to your wishlist!"
    elsif current_user.wishlist_items.include?(item)
      flash[:notice] = "Item removed from wishlist!"
      current_user.wishlist_items.delete(item)
    else
      flash[:notice] = "Item added to wishlist!"
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
    params.require(:item).permit(:price, :description, :image_url, :for_sale, :sold, :category_id, :featured, :featured_amount_paid)
  end

  def search_params
    params.permit(:search, :category, :price_range)
  end

  def require_admin
    unless current_user&.admin?
      redirect_to root_path, notice: "You must be an admin to access this page."
    end
  end

  def has_blank_field?
    blank_fields = user_params.select { |_, value| value.blank? }.keys
    unless blank_fields.empty?
      flash[:alert] = "The following fields are blank: #{blank_fields.join(', ')}"
    end
    !blank_fields.empty?
  end
end
