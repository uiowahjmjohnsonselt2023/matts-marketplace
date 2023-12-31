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
        post :create, params: { item: attributes_for(:item, price: '100 dollars', featured: false) }
        expect(response).to redirect_to(new_item_path)
        expect(flash[:alert]).to eq('Price must be a number greater than 0.')
      end
      it 'shows correct flash message when description or category is empty' do
        post :create, params: { item: attributes_for(:item, description: nil) }
        expect(response).to redirect_to(new_item_path)
        expect(flash[:alert]).to eq('Description or Category field is required.')
      end
      context 'and feature checkbox is checked' do
        it 'shows correct flash message when feature amount is not entered' do
          post :create, params: { item: attributes_for(:item, featured: true, featured_amount_paid: nil) }
          expect(response).to redirect_to(new_item_path)
          expect(flash[:alert]).to eq('Enter feature amount if you want to feature your item.')
        end
        it 'shows correct flash message when feature amount is not a number above 0' do
          post :create, params: { item: attributes_for(:item, featured: true, featured_amount_paid: 0) }
          expect(response).to redirect_to(new_item_path)
          expect(flash[:alert]).to eq('Feature amount must be a number greater than 0.')
        end
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

  describe '#search' do
    it 'redirects to items_path if search parameters are empty' do
      post :search, params: { search: '', category: '', price_range: '' }
      expect(flash[:alert]).to eq("Search terms included all items!")
      expect(response).to redirect_to(items_path)
    end
    it 'redirects to items_path if no items are found' do
      allow(Item).to receive(:search).and_return([])
      post :search, params: { search: '@$%&', category: 'Cars', price_range: '>500' }
      expect(flash[:alert]).to eq("No items found!")
      expect(response).to redirect_to(items_path)
    end
    it 'renders search_items_path if items are found' do
      items = [double('Item')]
      allow(Item).to receive(:search).and_return(items)
      post :search, params: { search: 'term', category: 'category', price_range: 'range' }
      expect(flash[:notice]).to eq("Found 1 items!")
      expect(response).to render_template(:search)
    end
  end

  describe '#simple_search' do
    it 'redirects to items_path if search parameter is empty' do
      post :simple_search, params: { search: '' }
      expect(response).to redirect_to(items_path)
    end
    it 'redirects to items_path if no items are found' do
      allow(Item).to receive(:search).and_return([])
      post :simple_search, params: { search: 'term' }
      expect(flash[:alert]).to eq("No items found!")
      expect(response).to redirect_to(items_path)
    end
    it 'renders search_items_path if items are found' do
      items = [double('Item')]
      allow(Item).to receive(:search).and_return(items)
      post :simple_search, params: { search: 'term' }
      expect(response).to render_template(:search)
    end
  end

  describe '#category_search' do
    before(:all) do
      @category = create(:category)
    end
    it 'redirects to items_path if category parameter is empty' do
      post :category_search, params: { category: '' }
      expect(response).to redirect_to(items_path)
    end
    it 'redirects to items_path if no items are found' do
      allow(Item).to receive(:search).and_return([])
      post :category_search, params: { category: @category.name }
      expect(flash[:alert]).to eq("No items found!")
      expect(response).to redirect_to(items_path)
    end
    it 'renders search_items_path if items are found' do
      items = [create(:item, category_id: @category.id)]
      allow(Item).to receive(:search).and_return(items)
      post :category_search, params: { category: @category.name }
      expect(response).to render_template(:search)
    end
  end

  describe '#search_by_user' do
    context 'when logged in' do
      before(:each) do
        sign_in @user
        @user2 = create(:user)
        sign_in @user2
      end
      it 'redirects to item_path if user_id is empty' do
        get :search_by_user, params: { user_id: ''}
        expect(response).to redirect_to(items_path)
      end
      it 'redirects to items_path with alert when user does not have any item' do
        get :search_by_user, params: { user_id: @user.id}
        expect(response).to redirect_to(items_path)
        expect(flash[:alert]).to eq("No items found!")
      end
      it 'redirects to search_items_path if user has items' do
        @item1 = create(:item, user: @user2, for_sale: true)
        @item2 = create(:item, user: @user2, for_sale: true)
        get :search_by_user, params: { user_id: @user2.id}
        expect(assigns(:items)).to contain_exactly(@item1, @item2)
        expect(response).to render_template('items/search')
      end
    end
  end

  describe '#toggle_wishlist' do
    context 'when logged in' do
      before(:each) do
        sign_in @user
      end
      it 'removes item from wishlist and sets flash notice if already in wishlist' do
        @user.wishlist_items << @item
        post :toggle_wishlist, params: { item_id: @item.id }
        expect(flash[:notice]).to eq("Item removed from wishlist!")
        expect(response).to redirect_to(root_path)
        expect(@user.wishlist_items).not_to include(@item)
      end
      it 'adds item to wishlist and sets flash notice if not in wishlist' do
        post :toggle_wishlist, params: { item_id: @item.id }
        expect(flash[:notice]).to eq("Item added to wishlist!")
        expect(response).to redirect_to(root_path)
        expect(@user.wishlist_items).to include(@item)
      end
      it 'does not allow users to add their own items to wishlist' do
        post :toggle_wishlist, params: { item_id: @user_item.id }
        expect(flash[:alert]).to eq("You cannot add your own items to your wishlist!")
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
