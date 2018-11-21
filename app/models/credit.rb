class Credit < ApplicationRecord
  belongs_to :person, counter_cache: true
  belongs_to :movie, counter_cache: true

  validates :person, presence: true
  validates :movie, presence: true

  JOBS = {
    'Director' => 'directing',
    'Writer' => 'writing',
    'Composer' => 'composing',
    'Editor' => 'editing',
    'Cinematographer' => 'cinematography',
    'Actor' => 'acting' }

  validates :job,
    presence: true,
    inclusion: { in: JOBS.keys, message: 'is invalid' },
    uniqueness: {
      scope: [:person_id, :movie_id],
      message: 'type credit already exists for this person/movie combination.'
    }
end
