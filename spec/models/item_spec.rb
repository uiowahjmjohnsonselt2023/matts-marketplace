require 'rails_helper'

describe Item do
  before(:each) do
    @user1 = create(:user_with_items)
    @item1 = create(:item, user: @user1)
  end

  it 'is valid with valid attributes' do
    expect(@item1).to be_valid
  end

  it 'is not valid without price' do
    item2 = build(:item, price: nil)
    expect(item2).to_not be_valid
  end

  it 'is not valid without description' do
    item2 = build(:item, description: nil)
    expect(item2).to_not be_valid
  end

  it 'only belongs to one user' do
    @user2 = create(:user, email: 'another@example.com', username: 'anotheruser')
    # User 2 create same item as user 1
    item2 = build(:item, user: @user2)
    expect(item2).not_to be_valid
  end

  describe 'search' do
    it 'calls search_explicit' do
      terms = nil
      categories = nil
      price_range = nil
      Item.search(terms, categories, price_range)
      expect(Item).to receive(:search_explicit).with(terms, categories, price_range, true)
    end
  end

  describe 'search_explicit method' do
    before(:each) do
      categories = ["Clothing", "Electronics", "Toys", "Books", "Home"]
      @items = build_list(:item, 10) do |item, i|
        item.description = "Item #{i + 1}"
        if i < 5
          item.price = 10 + i * 10
        elsif i == 5
          item.price = 100
        else
          item.price = 100 + 200 * (i - 5)
        end
        ##item.category = Category.create(name: categories[(i / 2) % 5])
        item.category_id = (i / 2) % 5
      end
    end

    it 'filters by search term' do
      terms = '3'
      categories = nil
      price_range = nil
      for_sale = true
      filtered_items = Item.search_explicit(terms, categories, price_range, for_sale)
      expected_items = @items.select { |item| item.description == "Item 3" }
      expect(filtered_items).to match_array(expected_items)
    end

    it 'filters by category' do
      terms = ''
      categories = ['Electronics']
      price_range = 'Any'
      for_sale = true
      filtered_items = Item.search_explicit(terms, categories, price_range, for_sale)
      expected_items = @items.select { |item| item.category_id == Category.find_by(name: 'Electronics').id }
      expect(filtered_items).to match_array(expected_items)
    end

    it 'filters by price (for range low to high)' do
      terms = ''
      categories = ['All Categories']
      price_range = '$50-100'
      for_sale = true
      filtered_items = Item.search_explicit(terms, categories, price_range, for_sale)
      expected_items = @items.select { |item| item.price >= 50 and item.price <= 100 }
      expect(filtered_items).to match_array(expected_items)
    end

    it 'filters by price (for range 500 or higher)' do
      terms = ''
      categories = ['All Categories']
      price_range = '>$500'
      for_sale = true
      filtered_items = Item.search_explicit(terms, categories, price_range, for_sale)
      expected_items = @items.select { |item| item.price >= 500}
      expect(filtered_items).to match_array(expected_items)
    end
  end
end