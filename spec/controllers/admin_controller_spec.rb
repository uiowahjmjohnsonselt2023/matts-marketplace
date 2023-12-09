require 'rails_helper'

describe AdminController, type: :controller do
  before(:each) do
    @admin = create(:admin)
    allow(controller).to receive(:current_user).and_return(@admin)
    sign_in @admin
  end
  describe '#manage_users' do
    it 'calls all in User model' do
      expect(User).to receive(:all)
      get :manage_users
    end
  end

  describe '#manage_purchases' do
    it 'calls all in Purchase model' do
      expect(Purchase).to receive(:all)
      get :manage_purchases
    end
  end

  describe '#manage_items' do
    it 'calls all in Item model' do
      expect(Item).to receive(:all)
      get :manage_items
    end
  end

  describe '#analytics' do
    it 'assigns purchase data correctly' do
      purchases = create_list(:purchase, 5)
      allow(Purchase).to receive(:includes).with(:item).and_return(Purchase)
      get :analytics
      expect(assigns(:purchases)).to eq(purchases)
    end
  end

  describe '#require_admin' do
    it 'disables users that are not admins from accessing page' do
      sign_out @admin
      normal_user = create(:user)
      allow(controller).to receive(:current_user).and_return(normal_user)
      sign_in normal_user
      get :manage_users
      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq('You must be an admin to access this page.')
    end
  end
end
