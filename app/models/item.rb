class Item < ActiveRecord::Base
  belongs_to :list

  validates :body, presence: true
end
