require 'rails_helper'

describe HomeController, type: :controller do
  describe '#index' do
    before(:each) do
      @featured_items = create_list(:featured_item, 5)
      @non_featured_items = create_list(:item, 3, for_sale: true)
      @categories = create_list(:category, 3)
    end
    it 'assigns featured items' do
      get :index
      expect(assigns(:featured_items)).to match_array(@featured_items)
    end
    it 'orders featured items by featured_amount_paid in descending order' do
      get :index
      expected_order = @featured_items.sort_by { |item| -item.featured_amount_paid }
      expect(assigns(:featured_items)).to eq(expected_order)
    end
  end
end