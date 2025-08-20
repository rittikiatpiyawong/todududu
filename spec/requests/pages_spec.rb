require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /brag_document" do
    it "returns http success" do
      get "/pages/brag_document"
      expect(response).to have_http_status(:success)
    end
  end

end
