class Counter < ActiveRecord::Base
  belongs_to :countable, polymorphic: true

  validates :countable, presence: true
end
