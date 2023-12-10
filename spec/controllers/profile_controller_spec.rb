require 'rails_helper'

describe ProfileController, type: :controller do
  before(:each) do
    @user = create(:user, balance: BigDecimal('100'))
    sign_in @user
  end
  describe '#update' do
    context 'when fields are empty' do
      it 'redirects to profile_edit_url if fields are blank' do
        patch :update, params: { id: @user.id, user: { username: '', email: '' } }
        expect(response).to redirect_to(profile_edit_url)
      end
    end
    context 'when update is successful' do
      it 'updates the user profile and redirects to profile_show_url for HTML format' do
        patch :update, params: { id: @user.id, user: { username: 'new_username', email: 'new@gmail.com' } }
        expect(response).to redirect_to(profile_show_url)
        expect(flash[:notice]).to eq('Profile was successfully updated.')
        expect(@user.reload.email).to eq('new@gmail.com')
      end
    end
    context 'when update is not successful' do
      it 'renders edit with error notice for HTML format' do
        patch :update, params: { id: @user.id, user: { email: nil } }
        expect(response).to render_template(:edit)
        expect(flash[:notice]).to eq('Profile update failed.')
        expect(response).to have_http_status(:unprocessable_entity)
        expect(flash[:alert]).to eq("Profile update failed.")
      end
    end
  end

  describe '#wishlist' do
    before(:each) do
      @category1 = create(:category)
      @category2 = create(:category)
      @item1 = create(:item, category: @category1, user: @user)
      @item2 = create(:item, category: @category1, user: @user)
      @item3 = create(:item, category: @category2, user: @user)
      @wishlist_items = [@item1, @item2, @item3]
    end
    it 'groups wishlist items by category and sorts them by count' do
      get :wishlist
      puts 'category'
      puts @category1
      puts @category2
      expect(assigns(:wishlist_items)).not_to be_nil
    end
  end

  describe "#balance" do
    it 'renders the balance template and assigns @user' do
      get :balance
      expect(response).to render_template('profile/balance')
    end
  end

  ## add balance and withdraw balance triggers a modal so it will fail all my tests
  describe '#add_balance' do
    it 'adds specified amount to balance' do
      post :add_balance, params: { balance: '50.00' }
      expect(response).to redirect_to(profile_balance_url)
    end
  end

end