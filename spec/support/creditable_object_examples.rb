shared_examples_for 'a creditable object' do
  it 'has many credits' do
    expect(object.credits).to be_empty
  end

  it 'has many directors (scoped through credits)' do
    expect(object.directing_credits).to be_empty
  end

  it 'has many writers (scoped through credits)' do
    expect(object.writing_credits).to be_empty
  end

  it 'has many composers (scoped through credits)' do
    expect(object.composing_credits).to be_empty
  end

  it 'has many editors (scoped through credits)' do
    expect(object.editing_credits).to be_empty
  end

  it 'has many cinematographers (scoped through credits)' do
    expect(object.cinematography_credits).to be_empty
  end

  it 'has many actors (scoped through credits)' do
    expect(object.acting_credits).to be_empty
  end
end
