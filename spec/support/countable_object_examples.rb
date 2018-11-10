shared_examples_for 'a countable object' do
  it 'has a directing credits count (through counter)' do
    expect(object.number_of_directing_credits).to eq 0
  end

  it 'has a writing credits count (through counter)' do
    expect(object.number_of_writing_credits).to eq 0
  end

  it 'has a composing credits count (through counter)' do
    expect(object.number_of_composing_credits).to eq 0
  end

  it 'has an editing credits count (through counter)' do
    expect(object.number_of_editing_credits).to eq 0
  end

  it 'has a cinematography credits count (through counter)' do
    expect(object.number_of_cinematography_credits).to eq 0
  end

  it 'has an acting credits count (through counter)' do
    expect(object.number_of_acting_credits).to eq 0
  end
end
