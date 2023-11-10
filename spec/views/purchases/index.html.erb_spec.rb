require 'rails_helper'

RSpec.describe "purchases/index", type: :view do
  before(:each) do
    assign(:purchases, [
      Purchase.create!(
        user: nil,
        item: nil
      ),
      Purchase.create!(
        user: nil,
        item: nil
      )
    ])
  end

  it "renders a list of purchases" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
    assert_select cell_selector, text: Regexp.new(nil.to_s), count: 2
  end
end
