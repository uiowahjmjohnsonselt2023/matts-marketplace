class ChatsController < ApplicationController
  before_action :set_user
  before_action :set_chat, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: %i[ show index new ]

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
    @chat = Chat.new(chat_params)

    respond_to do |format|
      if @chat.save
        format.html { redirect_to chat_url(@chat), notice: "Chat was successfully created." }
        format.json { render :show, status: :created, location: @chat }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
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
