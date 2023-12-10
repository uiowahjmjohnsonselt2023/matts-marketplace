require 'rails_helper'

describe PurchasesController, type: :controller do
  before(:each) do
    @user = create(:user)
    sign_in @user
  end
  describe '#index' do
  end
end