require 'rails_helper'

describe SellersController, type: :controller do
  before(:each) do
    @user = create(:user)
    sign_in @user
  end
  describe '#index' do
    it 'assigns instance variable instance and seller_items' do
      seller_item = create(:item, user: @user)
      get :index
      expect(assigns(:seller)).to eq(@user)
      expect(assigns(:seller_items)).to eq([seller_item])
      expect(response).to render_template(:index)
    end
  end

  describe "#new_item" do
    it "calls model method nes" do
      expect(Item).to receive(:new)
      get :new_item
      expect(assigns(:item)).to be_a_new(Item)
      expect(response).to render_template(:new_item)
    end
  end
end