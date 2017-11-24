require 'rails_helper'

RSpec.describe List, type: :model do
  let(:user) { create(:user) }
  let(:list) { create(:list, user: user, private: false) }

  it { is_expected.to belong_to(:user) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:user) }
  
  it { is_expected.to validate_length_of(:title).is_at_least(1) }

  describe "attributes" do
    it "has title, user, and private attributes" do
      expect(list).to have_attributes(title: list.title, user: user, private: false)
    end
  end
end
