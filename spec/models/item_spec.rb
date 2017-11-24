require 'rails_helper'

RSpec.describe Item, type: :model do
  let(:list) { create(:list) }
  let(:item) { create(:item, list: list) }

  it { is_expected.to belong_to (:list) }
  it { is_expected.to validate_presence_of(:body) }

end
