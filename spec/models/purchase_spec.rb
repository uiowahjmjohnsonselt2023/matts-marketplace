require 'rails_helper'

RSpec.describe Purchase, type: :model do
  before(:each) do
    @seller = create(:user, balance: 10)
    @buyer = create(:user)
    @item = create(:item, price:50, for_sale: true)
    @purchase = create(:purchase, seller: @seller, buyer: @buyer, item: @item)
  end

  it 'belongs to seller and buyer and item' do
    expect(@purchase.seller).to eq(@seller)
    expect(@purchase.buyer).to eq(@buyer)
    expect(@purchase.item).to eq(@item)
  end

  describe 'confirm_purchase' do
    context 'when buyer has enough balance' do
      it 'purchase is successful and balance changes for both seller and buyer' do
        rich_user = create(:user,  balance: 100)
        successful_purchase = create(:purchase, seller: @seller, buyer: rich_user, item: @item)
        allow(rich_user).to receive(:save).and_return(true)
        allow(@seller).to receive(:save).and_return(true)
        allow(@item).to receive(:save).and_return(true)
        expect(successful_purchase.confirm_purchase?).to be true
        expect(rich_user.reload.balance).to eq(50)
        expect(@seller.reload.balance).to eq(60)
      end
      context 'when buyer does not have enough balance' do
        it 'purchase is not successful' do
          poor_user = create(:user,  balance: 0)
          unsuccessful_purchase = create(:purchase, seller: @seller, buyer: poor_user, item: @item)
          allow(poor_user).to receive(:save).and_return(true)
          allow(@seller).to receive(:save).and_return(true)
          allow(@item).to receive(:save).and_return(true)
          expect(unsuccessful_purchase.confirm_purchase?).to be false
        end
      end
    end
  end

end
