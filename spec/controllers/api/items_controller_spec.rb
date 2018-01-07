require 'rails_helper'

RSpec.describe Api::ItemsController, type: :controller do
  let(:my_user) { create(:user) }
  let(:second_user) { create(:user) }
  let(:my_list) { create(:list, user: my_user) }
  let(:my_item) { create(:item, list: my_list) }

  context "authorized user" do
    let (:user) { "testuser" }
    let (:pw) { "testpass" }

    before do
      auth_user = create(:user, username: user, password: pw, email: "test@gmail.com")
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "POST create" do
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

    describe "PUT update" do
      it "returns http success" do
        new_completed = true
        put :update, list_id: my_list.id, id: my_item.id, item: {completed: new_completed}
        expect(response).to have_http_status(:success)
      end

      it "updates item with expected attributes" do
        new_completed = true
        put :update, list_id: my_list.id, id: my_item.id, item: {completed: new_completed}

        updated_item = assigns(:item)
        expect(updated_item.id).to eq my_item.id
        expect(updated_item.completed).to eq true
      end
    end
  end

  context "unauthorized user" do
    before do
      user = "testuser"
      pw = "wrongpass"
      request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(user,pw)
    end

    describe "POST create" do
      it "returns 401 error" do
        post :create, list_id: my_list.id, item: {body: "Wash the Dog"}
        expect(response.status).to eq 401
      end
    end

    describe "PUT update" do
      it "returns 401 error" do
        new_completed = true
        put :update, list_id: my_list.id, id: my_item.id, item: {completed: new_completed}
        expect(response.status).to eq 401
      end
    end
  end

end
