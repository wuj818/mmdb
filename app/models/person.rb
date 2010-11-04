class Person < ActiveRecord::Base
  include CreditScopesAndCounts

  validates :name,
    :presence => true

  validates :imdb_url,
    :presence => true,
    :uniqueness => true

  validates :permalink,
    :uniqueness => true

  before_save :create_permalink

  before_save :create_sort_name

  has_many :credits, :include => :movie, :dependent => :destroy

  has_one :counter, :as => :countable, :dependent => :destroy

  def to_param
    self.permalink
  end

  Credit::JOBS.values.each do |credit_type|
    define_method "sorted_#{credit_type}_credits" do
      self.send("#{credit_type}_credits").joins(:movie).order('year DESC')
    end
  end

  def self.[](name)
    self.find_by_name name
  end

  private

  def create_permalink
    return unless self.permalink.blank?
    return if self.name.blank?
    result = self.name.to_permalink
    dup_count = Person.where(:name => self.name).count
    result << "-#{dup_count+1}" unless dup_count == 0
    self.permalink = result
  end

  def create_sort_name
    return unless self.sort_name.blank?
    self.sort_name = self.name.to_sort_column
  end
end
