class Credit < ActiveRecord::Base
  belongs_to :person
  belongs_to :movie

  validates :person, :presence => true
  validates :movie, :presence => true

  JOBS = %w(Director Writer Composer Editor Cinematographer Actor)

  validates :job,
    :presence => true,
    :inclusion => { :in => JOBS, :message => 'is invalid' },
    :uniqueness => {
      :scope => [:person_id, :movie_id],
      :message => 'type credit already exists for this person/movie combination.'
    }
end
