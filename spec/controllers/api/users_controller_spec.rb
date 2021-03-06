require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let (:existing_user) { create(:user) }

  context "authorized user" do
    let (:user) { "testuser" }
    let (:pw) { "testpass" }

    before do
      @auth_user = create(:user, username: user, password: pw, email: "test@email.com")
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "GET index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end

      it "assigns User.all to user" do
        get :index
        expect(assigns(:users)).to eq([@auth_user])
      end
    end

    describe "POST create" do
      it "increases the number of users by 1" do
        expect{ post :create, user: {name: "Test User", email: "test@test.com", username: "testuser2", password: "password" } }.to change(User,:count).by(1)
      end

      it "returns http success" do
        post :create, user: {name: "Test User", email: "test@test.com", username: "testuser2", password: "password" }
        expect(response).to have_http_status(:success)
      end

      it "assigns User.last to @user" do
        post :create, user: {name: "Test User", email: "test@test.com", username: "testuser2", password: "password" }
        expect(assigns(:user)).to eq User.last
      end

      it "requires a password" do
        post :create, user: {name: "Test User", email: "test@test.com", username: "testuser2" }
        expect(response.status).to eq 422
      end

      it "requires a username" do
        post :create, user: {name: "Test User", email: "test@test.com", password: "password" }
        expect(response.status).to eq 422
      end
    end

    describe "DELETE destroy" do
      it "deletes the user" do
        delete :destroy, {id: existing_user.id}
        count = List.where({id: existing_user.id}).size
        expect(count).to eq 0
      end

      it "returns 204 status" do
        delete :destroy, {id: existing_user.id}
        expect(response.status).to eq 204
      end
    end

  end

  context "unauthorized user" do
    before(:each) do
      user = "testuser"
      pw = "wrongpass"
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "GET index" do
      it "returns 401 error" do
        get :index
        expect(response.status).to eq 401
      end
    end

    describe "POST create" do
      it "returns 401 error" do
        post :create, user: {name: "Test User", email: "test@test.com", username: "testuser2", password: "password" }
        expect(response.status).to eq 401
      end
    end

    describe "DELETE destroy" do
      it "returns 401 error" do
        delete :destroy, {id: existing_user.id}
        expect(response.status).to eq 401
      end
    end
  end
end
