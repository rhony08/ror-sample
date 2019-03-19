require 'rails_helper'

RSpec.describe StoreController, type: :controller do

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "render the index template" do
    	get :index
    	expect(response).to render_template(:index)
    end

    it "assigns @products" do
    	product = create(:product)
    	get :index
    	expect(assigns[:products]).to eq([product])
    end
  end

end
