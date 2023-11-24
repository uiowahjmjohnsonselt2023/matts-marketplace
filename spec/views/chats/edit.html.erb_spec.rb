require 'rails_helper'

RSpec.describe "chats/edit", type: :view do
  let(:chat) {
    Chat.create!(
      buyer: nil,
      seller: nil
    )
  }

  before(:each) do
    assign(:chat, chat)
  end

  it "renders the edit chat form" do
    render

    assert_select "form[action=?][method=?]", chat_path(chat), "post" do

      assert_select "input[name=?]", "chat[buyer_id]"

      assert_select "input[name=?]", "chat[seller_id]"
    end
  end
end
