require 'rails_helper'

describe User do
  before(:each) do
    @user1 = create(:user)
  end

  it "is valid with valid attributes" do
    expect(@user1).to be_valid
  end

  it "has a unique email address" do
    user2 = build(:user, email: "user@example.com")
    expect(user2).to_not be_valid
  end

  it "has a unique username" do
    user2 = build(:user, username: "superuser")
    expect(user2).to_not be_valid
  end

  it "is not valid without a password" do
    user2 = build(:user, password: nil)
    expect(user2).to_not be_valid
  end

  it "is not valid without an email" do
    user2 = build(:user, email: nil)
    expect(user2).to_not be_valid
  end
end
