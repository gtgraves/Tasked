require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
  let(:my_user) { create(:user) }
  let(:new_user_attributes) do
    {
      name: "Benjamin Sky",
      email: "benjamin@sky.com",
      username: "benjamin",
      password: "broken"
    }
  end

  describe "GET index" do
    before do
      user = User.create!(name: "George", email: "test@user.com", username: "gtgraves", password: "password")
    end
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns User.all to user" do
      get :index
      expect(assigns(:users)).to eq([my_user])
    end
  end

end
