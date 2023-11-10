require 'rails_helper'

RSpec.describe "Buyers", type: :request do
  describe "GET /index" do
    it "returns http success" do
      get "/buyers/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/buyers/show"
      expect(response).to have_http_status(:success)
    end
  end

end
