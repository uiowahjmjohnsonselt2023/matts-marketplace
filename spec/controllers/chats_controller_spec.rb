require 'rails_helper'

describe ChatsController, type: :controller do
  before(:each) do
    @user = create(:user)
    @buyer = create(:user)
    @seller = create(:user)
    @chat = create(:chat, buyer: @buyer, seller: @seller)
  end
  describe '#show' do
    it 'redirects to chats_path with notice when user not authorized' do
      sign_in @user
      get :show, params: { id: @chat.id }
      expect(response).to redirect_to(chats_path)
      expect(flash[:notice]).to eq("Not authorized!")
    end
    it 'assigns instance variable messages to instance variable chat' do
      sign_in @buyer
      get :show, params: { id: @chat.id }
      expect(assigns(:messages)).to eq(@chat.messages)
      expect(response).to render_template(:show)
    end
  end
end