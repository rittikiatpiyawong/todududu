require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  describe 'GET #brag_document' do
    before { get :brag_document }

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end
end
