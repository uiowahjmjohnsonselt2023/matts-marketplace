require 'rails_helper'

describe BuyersController, type: :controller do
  describe '#index' do
    it 'returns a successful response' do
      get :index
      expect(response).to have_http_status(:ok)
    end
    it 'returns a 200 response' do
      get :index
      expect(response).to have_http_status '200'
    end
    it 'assigns instance variable items with items available for sale' do
      items = create_list(:item, 5, for_sale: true)
      get :index
      expect(assigns(:items)).to match_array(items)
      expect(response).to render_template(:index)
    end
  end

  describe '#show' do
    before(:each) do
      @item = create(:item, for_sale: true)
    end
    it 'responds successfully' do
      get :show, params: {id: @item.id}
      expect(response).to have_http_status(:ok)
    end
    it 'returns a 200 response' do
      get :show, params: {id: @item.id}
      expect(response).to have_http_status "200"
    end
    it 'assigns instance variable item for sale by ID' do
      get :show, params: { id: @item.id }
      expect(assigns(:item)).to eq(@item)
      expect(response).to render_template(:show)
    end
  end

  describe '#checkout' do
    before(:each) do
      @user = create(:user)
    end
    it 'assigns instance variables item and user, and initializes a new purchase' do
      sign_in @user
      item = create(:item, for_sale: true)
      get :checkout, params: { id: item.id }
      expect(assigns(:item)).to eq(item)
      expect(assigns(:user)).to eq(@user)
      expect(assigns(:purchase)).to be_a_new(Purchase)
      expect(response).to render_template(:checkout)
    end
    it 'redirects to sign in page if user is not logged in' do
      sign_out(@user)
      item = create(:item, for_sale: true)
      get :checkout, params: { id: item.id }
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end