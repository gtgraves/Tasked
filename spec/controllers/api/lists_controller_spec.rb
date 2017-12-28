require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do
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

      it "returns http success" do
        post :create, user_id: my_user.id, list: {title: "All of My Todos" }
        expect(response).to have_http_status(:success)
      end

      it "increases the number of lists by 1" do
        expect{ post :create, user_id: my_user.id, list: {title: "All of My Todos" } }.to change(List,:count).by(1)
      end

      it "assigns List.last to @list" do
        post :create, user_id: my_user.id, list: {title: "All of My Todos" }
        expect(assigns(:list)).to eq List.last
      end

      it "requires a list title" do
        post :create, user_id: my_user.id, list: {title: nil }
        expect(response.status).to eq 422
      end
    end
  end

  context "unauthoirzed user" do
    before(:each) do
      user = "testuser"
      pw = "wrongpass"
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "POST create" do
      let(:my_user) { create(:user) }

      it "returns 401 error" do
        post :create, user_id: my_user.id, list: {title: "All of My Todos" }
        expect(response.status).to eq 401
      end
    end
  end
end
