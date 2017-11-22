class List < ActiveRecord::Base
  belongs_to :user
  has_many :items

  validates :title, length: { minimum: 1, maximum: 25 }, presence: true
  validates :user, presence: true
end
