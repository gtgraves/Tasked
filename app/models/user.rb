class User < ActiveRecord::Base
  has_many :lists

  validates :name, length: { minimum: 1, maximum: 20}, presence: true
  validates :email, length: { minimum: 5, maximum: 254 }, presence: true, uniqueness: { case_sensitive: false }

end