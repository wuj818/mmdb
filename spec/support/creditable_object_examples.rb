shared_examples_for 'a creditable object' do
  describe 'Associations' do
    it 'has many credits' do
      object.credits.should be_empty
    end

    it 'has many directors (scoped through credits)' do
      object.directing_credits.should be_empty
    end

    it 'has many writers (scoped through credits)' do
      object.writing_credits.should be_empty
    end

    it 'has many composers (scoped through credits)' do
      object.composing_credits.should be_empty
    end

    it 'has many editors (scoped through credits)' do
      object.editing_credits.should be_empty
    end

    it 'has many cinematographers (scoped through credits)' do
      object.cinematography_credits.should be_empty
    end

    it 'has many actors (scoped through credits)' do
      object.acting_credits.should be_empty
    end
  end
end
