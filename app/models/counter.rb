class Counter < ApplicationRecord
  belongs_to :countable, polymorphic: true

  validates :countable, presence: true
end
