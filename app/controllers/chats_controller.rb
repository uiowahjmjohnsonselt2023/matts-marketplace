class ChatsController < ApplicationController
  before_action :set_user
  before_action :set_chat, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /chats or /chats.json
  def index
  end

  # GET /chats/1 or /chats/1.json
  def show
    if current_user != @chat.buyer and current_user != @chat.seller
      redirect_to chats_path, notice: "Not authorized!" and return
    end
    @messages = @chat.messages
  end

  # GET /chats/new
  def new
    @chat = Chat.new
  end

  # GET /chats/1/edit
  def edit
  end

  # POST /chats or /chats.json
  def create
    # Try to find an existing chat with the same buyer, seller, and item
    @chat = Chat.find_by(buyer_id: current_user.id, seller_id: chat_params[:seller_id], item_id: chat_params[:item_id])

    if @chat
      # If a chat is found, redirect to the chat and display a warning message
      redirect_to @chat, alert: 'Chat already exists.'
    else
      # If no chat is found, create a new chat
      @chat = Chat.new(chat_params)
      @chat.buyer_id = current_user.id
      @chat.seller_id = chat_params[:seller_id]
      @chat.item_id = chat_params[:item_id]

      if @chat.save
        redirect_to @chat, notice: 'Chat was successfully created.'
      else
        flash[:alert] = 'There was an error creating the chat.'
        render :new
      end
    end
  end

  # PATCH/PUT /chats/1 or /chats/1.json
  def update
    respond_to do |format|
      if @chat.update(chat_params)
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully updated." }
        format.json { render :show, status: :ok, location: @chat }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1 or /chats/1.json
  def destroy
    @chat.destroy!
    respond_to do |format|
      format.html { redirect_to chats_url, notice: "Chat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def send_message
    @chat = Chat.find(params[:id])
    @user.messages.create(content: params[:content], chat_id: params[:id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chat
      @chat = Chat.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def chat_params
      params.require(:chat).permit(:buyer_id, :seller_id, :item_id)
    end

    def set_user
      @user = current_user
    end
end
