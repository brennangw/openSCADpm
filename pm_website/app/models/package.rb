class Package < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, length: { maximum: 50 },
                   uniqueness: true
end
