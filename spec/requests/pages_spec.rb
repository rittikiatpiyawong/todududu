require 'rails_helper'

RSpec.describe "Pages", type: :request do
  describe "GET /brag-document" do
    before { get brag_document_path }

    it "returns http success" do
      expect(response).to have_http_status(:success)
    end

    it "renders the brag document page" do
      expect(response.body).to be_present
    end
  end
end
