require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  before do
    @auth_user = create(:user, username: "testuser", password: "testpass", email: "test@email.com")
  end

  context "authorized user" do
    before(:each) do
      user = "testuser"
      pw = "testpass"
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "POST create" do
      let(:my_user) { create(:user) }
      let(:my_list) { create(:list, user: my_user) }

      it "returns http success" do
        post :create, list_id: my_list.id, item: {body: "Wash the Dog"}
        expect(response).to have_http_status(:success)
      end

      it "increases the number of items by 1" do
        expect{ post :create, list_id: my_list.id, item: {body: "Wash the Dog"} }.to change(Item,:count).by(1)
      end

      it "assigns Item.last to @item" do
        post :create, list_id: my_list.id, item: {body: "Wash the Dog"}
        expect(assigns(:item)).to eq Item.last
      end

      it "requires an item body" do
        post :create, list_id: my_list.id, item: {body: nil}
        expect(response.status).to eq 422
      end
    end
  end

  context "unauthorized user" do
    before(:each) do
      user = "testuser"
      pw = "wrongpass"
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "Post create" do
      let(:my_user) { create(:user) }
      let(:my_list) { create(:list, user: my_user) }

      it "returns 401 error" do
        post :create, list_id: my_list.id, item: {body: "Wash the Dog"}
        expect(response.status).to eq 401
      end
    end
  end

end
