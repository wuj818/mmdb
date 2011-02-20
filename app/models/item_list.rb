class ItemList < ActiveRecord::Base
  validates :name, :presence => true
  validates :position, :numericality => true

  before_save :create_permalink

  def self.to_s
    'List'
  end

  def to_param
    self.permalink
  end

  private

  def create_permalink
    self.permalink = self.name.to_permalink
  end
end
