require 'rails_helper'

describe PurchasesController, type: :controller do
  before(:each) do
    @item = create(:item)
    @item2 = create(:item)
    @user2 = create(:user)
    @seller = create(:user, balance: 50)
    @buyer = create(:user, balance: 100)
    @purchase = create(:purchase, item: @item, seller: @seller, buyer: @buyer)
    sign_in @buyer
  end

  describe '#index' do
    it "assigns purchase to current user's purchase" do
      get :index
      expect(response).to have_http_status(:success)
      expect(assigns(:purchases)).not_to be_nil
    end
  end

  describe '#new' do
    it 'assigns a new Purchase instance to @purchase' do
      get :new
      expect(assigns(:purchase)).to be_a_new(Purchase)
    end

    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe '#create' do
    it 'gives a notice when purchase is successful' do
      let(:purchase) { create(:purchase) }
      valid_params =   {
        item_id: @item.id,
        seller_id: @seller.id,
        buyer_id: @buyer.id,
      }
      allow_any_instance_of(Purchase).to receive(:confirm_purchase?).and_return(true)
      expect {
        post :create, params: { purchase: valid_params }
      }.to change(Chat, :count).by(1)
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("Purchase successful! A chat has been created for you and the seller to discuss delivery.")
    end
    it 'redirects with error message when purchase confirmation fails' do
      valid_params = {
        item_id: @item.id,
        seller_id: @seller.id,
        buyer_id: @buyer.id,
      }
      allow_any_instance_of(Purchase).to receive(:confirm_purchase?).and_return(false)
      expect {
        post :create, params: { purchase: valid_params }
      }.not_to change(Chat, :count)
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).not_to be_nil # Check for error message in flash
    end
  end

  describe '#update' do
    before(:each) do
      @admin = create(:admin)
      sign_in @admin
    end
    context 'with valid params' do
      it 'updates the purchase and redirects to show page' do
        valid_params =   {
          item_id: @item.id,
          seller_id: @seller.id,
          buyer_id: @user2.id,
        }
        put :update, params: { id: @purchase.id, purchase: valid_params }
        expect(response).to redirect_to(purchase_url(@purchase))
        expect(flash[:notice]).to eq('Purchase was successfully updated.')
      end
    end
    context 'with invalid params' do
      it 'renders edit template on unsuccessful update' do
        invalid_params =   {
          item_id: nil,
          seller_id: @seller.id,
          buyer_id: @user2.id,
        }
        put :update, params: { id: @purchase.id, purchase: invalid_params }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end
  end

  describe '#destroy' do
    before(:each) do
      @admin = create(:admin)
      sign_in @admin
    end
    it 'destroys the purchase and redirects' do
      expect {
        delete :destroy, params: { id: @purchase.id }
      }.to change(Purchase, :count).by(-1)
      expect(response).to redirect_to(admin_manage_purchases_url)
      expect(flash[:notice]).to eq('Purchase was successfully destroyed.')
    end
  end

  describe 'require_admin' do
    it 'shows alert when you are not admin' do
      not_admin_user = create(:user)
      valid_params =   {
        item_id: @item.id,
        seller_id: @seller.id,
        buyer_id: @user2.id,
      }
      put :update, params: { id: @purchase.id, purchase: valid_params }
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You must be an admin to access this page.")
    end
  end
end