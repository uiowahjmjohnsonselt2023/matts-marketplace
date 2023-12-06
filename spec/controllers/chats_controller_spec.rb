require 'rails_helper'

describe ChatsController, type: :controller do
  before(:each) do
    @user = create(:user)
    @buyer = create(:user)
    @seller = create(:user)
    @item = create(:item)
  end
  describe '#show' do
    it 'redirects to chats_path with notice when user not authorized' do
      sign_in @user
      chat = create(:chat, buyer: @buyer, seller: @seller)
      get :show, params: { id: chat.id }
      expect(response).to redirect_to(chats_path)
      expect(flash[:notice]).to eq("Not authorized!")
    end
    it 'assigns instance variable messages to instance variable chat' do
      sign_in @buyer
      chat = create(:chat, buyer: @buyer, seller: @seller)
      get :show, params: { id: chat.id }
      expect(assigns(:messages)).to eq(chat.messages)
      expect(response).to render_template(:show)
    end
  end

  describe '#new' do
    it 'calls model method new' do
      sign_in @buyer
      fake_chat = double('chat')
      allow(Chat).to receive(:new).and_return(fake_chat)
      post :new
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    before do
      sign_in @buyer
    end
    context 'when chat exisits' do
      it 'redirects to existing chat with alert if existing chat is found' do
        chat = create(:chat, buyer: @buyer, seller: @seller, item: @item)
        post :create, params: { chat: { seller_id: @seller.id, item_id: @item.id } }
        expect(response).to redirect_to(chat)
        expect(flash[:alert]).to eq('Chat already exists.')
      end
    end
    context "when chat doesn't exist" do
      it 'creates a new chat' do
        expect {
          post :create, params: { chat: { seller_id: @seller.id, item_id: @item.id } }
        }.to change(Chat, :count).by(1)
        new_chat = Chat.last
        expect(response).to redirect_to(new_chat)
        expect(flash[:notice]).to eq('Chat was successfully created.')
      end
      it 'renders new chat and shows alert if there was an error creating chat' do
        allow_any_instance_of(Chat).to receive(:save).and_return(false)
        post :create, params: { chat: { seller_id: @seller.id, item_id: @item.id } }
        expect(response).to render_template(:new)
        expect(flash[:alert]).to eq('There was an error creating the chat.')
      end
    end
  end

  describe '#update' do
    before do
      sign_in @buyer
      @chat = create(:chat, buyer: @buyer, seller: @seller, item: @item)
    end
    it 'updates the chat and redirects to the chat page with valid input' do
      valid_params = { buyer_id: @user.id }
      patch :update, params: { id: @chat.id, chat: valid_params }
      expect(response).to redirect_to(chat_url(@chat))
      expect(flash[:notice]).to eq("Chat was successfully updated.")
    end
    it 'renders the edit template with an error message with invalid input' do
      invalid_params = { buyer_id: nil }
      patch :update, params: { id: @chat.id, chat: invalid_params }
      expect(response).to render_template(:edit)
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe '#destroy' do
    it 'deletes the chat and redirects to chats_url' do
      sign_in @buyer
      @chat = create(:chat, buyer: @buyer, seller: @seller, item: @item)
      expect {
        delete :destroy, params: { id: @chat.id }
      }.to change(Chat, :count).by(-1)
      expect(response).to redirect_to(chats_url)
      expect(flash[:notice]).to eq("Chat was successfully destroyed.")
    end
  end

  describe '#send_message' do
    it 'creates a message and assigns it to user' do
      sign_in @buyer
      @chat = create(:chat, buyer: @buyer, seller: @seller, item: @item)
      fake_chat = double('chat')
      allow(Chat).to receive(:find).with(@chat.id.to_s).and_return(fake_chat)
      post :send_message, params: { id: @chat.id }
    end
  end
end