class ItemList < ActiveRecord::Base
  validates :name,
    presence: true,
    uniqueness: true
  validates :position, numericality: { greater_than_or_equal_to: 0 }

  before_save :create_permalink

  has_many :listings, include: 'movie', dependent: :destroy
  has_many :movies, through: :listings

  def to_param
    self.permalink
  end

  private

  def create_permalink
    self.permalink = self.name.to_permalink
  end
end
