require 'rails_helper'

describe ItemsController, type: :controller do
  before(:each) do
    @user = create(:user)
    @user_with_items = create(:user_with_items)
    @item = create(:item)
    @user_item = create(:item, user: @user)
  end
  describe '#index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
    it 'returns a 200 response' do
      get :index
      expect(response).to have_http_status '200'
    end
  end

  describe '#new' do
    context 'when logged in' do
      before(:each) do
        sign_in @user
      end
      it "assigns a new item to @item" do
        get :new
        expect(assigns(:item)).to be_a_new(Item)
      end
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
      it "calls Item.new" do
        expect(Item).to receive(:new)
        get :new
      end
    end
  end

  describe '#edit' do
    context 'when logged in' do
      before(:each) do
        sign_in @user
      end
      it 'assigns the requested item to @item' do
        get :edit, params: { id: @item.id }
        expect(assigns(:item)).to eq(@item)
      end
      it 'renders the edit template' do
        get :edit, params: { id: @item.id }
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#create' do
    context 'when logged in' do
      before(:each) do
        sign_in @user
      end
      it 'creates a new item and redirects to sellers_path with valid input' do
        post :create, params: { item: attributes_for(:item) }
        expect(response).to redirect_to(sellers_path)
        expect(flash[:notice]).to eq('Item is on the market.')
      end
      it 'shows correct flash message when price input is not a number' do
        post :create, params: { item: attributes_for(:item, price: '100 dollars') }
        expect(response).to redirect_to(new_item_path)
        expect(flash[:alert]).to eq('Price must be a number greater than 0.')
      end
      it 'shows correct flash message when description or category is empty' do
        post :create, params: { item: attributes_for(:item, description: nil) }
        expect(response).to redirect_to(new_item_path)
        expect(flash[:alert]).to eq('Description or Category field is required')
      end
    end
  end

  describe '#update' do
    context 'when logged in' do
      before(:each) do
        sign_in @user
      end
      it 'updates the item and redirects to sellers_path with valid input' do
        new_params = { price: 123 }
        patch :update, params: {id: @item.id, item: new_params}
        expect(@item.reload.price).to eq(123)
        expect(response).to redirect_to(sellers_path)
        expect(flash[:notice]).to eq('Item was successfully updated.')
      end
      it 'shows correct flash message when price input is not a number' do
        new_params = { price: '123' }
        patch :update, params: {id: @item.id, item: new_params}
        expect(response).to redirect_to(edit_item_path)
        expect(flash[:alert]).to eq('Price must be a number greater than 0.')
      end
      it 'shows correct flash message when description or category is empty' do
        new_params = { description: nil }
        patch :update, params: {id: @item.id, item: new_params}
        expect(response).to redirect_to(edit_item_path)
        expect(flash[:alert]).to eq('Description or Category field is required')
      end
    end
  end

  describe '#destroy' do
    context 'when logged in' do
      before(:each) do
        sign_in @user
      end
      it 'deletes an item' do
        expect {
          delete :destroy, params: {id: @item.id}
        }.to change(@user.items, :count).by(-1)
      end
      it 'redirects the sellers_path with correct flash message' do
        delete :destroy, params: {id: @item.id}
        expect(response).to redirect_to sellers_path
        expect(flash[:notice]).to eq('Item was successfully deleted.')
      end
    end
  end
end
