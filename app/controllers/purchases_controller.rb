class PurchasesController < ApplicationController
  before_action :set_purchase, only: %i[ show edit update destroy ]
  before_action :authenticate_user!
  before_action :require_admin, only: %i[ edit update destroy ]


  # GET /purchases or /purchases.json
  def index
    @purchases = current_user.buyer_purchases
  end

  # GET /purchases/1 or /purchases/1.json
  def show
  end

  # GET /purchases/new
  def new
    @purchase = Purchase.new
  end

  # GET /purchases/1/edit
  def edit
  end

  # POST /purchases or /purchases.json
  def create
    @purchase = Purchase.new(purchase_params)
    if @purchase.confirm_purchase?
      # Redirect to the chats_create controller action
      chat = Chat.create!(buyer_id: @purchase.buyer_id, seller_id: @purchase.seller_id, item_id: @purchase.item_id)
      redirect_to :root, notice: "Purchase successful! A chat has been created for you and the seller to discuss delivery."
    else
      flash[:alert] = @purchase.errors.full_messages.join(', ')
      redirect_to :root
    end
  end

  # PATCH/PUT /purchases/1 or /purchases/1.json
  def update
    respond_to do |format|
      if @purchase.update(purchase_params)
        format.html { redirect_to purchase_url(@purchase), notice: "Purchase was successfully updated." }
        format.json { render :show, status: :ok, location: @purchase }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @purchase.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /purchases/1 or /purchases/1.json
  def destroy
    @purchase.destroy!

    respond_to do |format|
      format.html { redirect_to admin_manage_purchases_url, notice: "Purchase was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_purchase
      @purchase = Purchase.find_by(item_id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def purchase_params
      params.require(:purchase).permit(:seller_id, :buyer_id, :item_id)
    end

    def require_admin
      unless current_user&.admin?
        redirect_to root_path, notice: "You must be an admin to access this page."
      end
    end
end
