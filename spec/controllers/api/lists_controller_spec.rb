require 'rails_helper'

RSpec.describe Api::ListsController, type: :controller do
  context "authorized user" do
    let (:user) { "testuser" }
    let (:pw) { "testpass" }
    let(:my_user) { create(:user) }
    let(:existing_list) { create(:list, user: my_user) }

    before do
      @auth_user = create(:user, username: user, password: pw, email: "test@email.com")
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "POST create" do

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

    describe "PUT update" do
      it "returns http success" do
        new_private = true
        put :update, user_id: my_user.id, id: existing_list.id, list: {private: new_private}
        expect(response).to have_http_status(:success)
      end

      it "updates list with expected attributes" do
        new_private = true
        put :update, user_id: my_user.id, id: existing_list.id, list: {private: new_private}

        updated_list = assigns(:list)
        expect(updated_list.id).to eq existing_list.id
        expect(updated_list.private).to eq true
      end
    end

    describe "DELETE destroy" do
      it "deletes the list" do
        delete :destroy, user_id: my_user.id, id: existing_list.id
        count = Item.where({id: existing_list.id}).size
        expect(count).to eq 0
      end

      it "returns 204 status" do
        delete :destroy, user_id: my_user.id, id: existing_list.id
        expect(response.status).to eq 204
      end
    end
  end

  context "unauthorized user" do
    let(:my_user) { create(:user) }
    let(:existing_list) { create(:list, user: my_user) }

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

    describe "PUT update" do
      it "returns 401 error" do
        new_private = true
        put :update, user_id: my_user.id, id: existing_list.id, list: {private: new_private}
        expect(response.status).to eq 401
      end
    end

    describe "DELETE destroy" do
      it "returns 401 error" do
        delete :destroy, user_id: my_user.id, id: existing_list.id
        expect(response.status).to eq 401
      end
    end
  end
end
