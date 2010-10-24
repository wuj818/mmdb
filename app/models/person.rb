class Person < ActiveRecord::Base
  include CreditScopes

  validates :name,
    :presence => true

  validates :imdb_url,
    :presence => true,
    :uniqueness => true

  validates :permalink,
    :uniqueness => true

  before_save :create_permalink

  has_many :credits, :include => :movie, :dependent => :destroy

  def to_param
    self.permalink
  end

  private

  def create_permalink
    return unless self.permalink.blank?
    result = self.name.to_permalink
    dup_count = Person.where(:name => self.name).count
    result << "-#{dup_count+1}" unless dup_count == 0
    self.permalink = result
  end
end
