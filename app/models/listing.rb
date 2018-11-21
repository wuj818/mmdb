class Listing < ApplicationRecord
  belongs_to :item_list, touch: true
  belongs_to :movie

  validates :item_list, presence: true
  validates :movie, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 0 }
  validates :movie_id,
    uniqueness: {
      scope: 'item_list_id',
      message: 'is already contained in this list.'
    }

  default_scope -> { order(:position) }
end
