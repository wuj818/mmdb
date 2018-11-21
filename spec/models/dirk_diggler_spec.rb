require 'rails_helper'

describe DirkDiggler do
  before { allow(Mechanize).to receive(:new).and_return instance_double('Mechanize', 'user_agent=' => true, get: true) }

  it 'requires an IMDB url' do
    expect { DirkDiggler.new }.to raise_error ArgumentError
  end

  it 'automatically removes any url params' do
    @diggler = DirkDiggler.new 'http://www.imdb.com/title/tt0118749/?ref_=nv_sr_1'
    expect(@diggler.target).to eq 'http://www.imdb.com/title/tt0118749/'
  end

  it 'automatically appends a slash to the IMDB url if needed' do
    @diggler = DirkDiggler.new 'http://www.imdb.com/title/tt0118749/'
    expect(@diggler.target).to eq 'http://www.imdb.com/title/tt0118749/'

    @diggler = DirkDiggler.new 'http://www.imdb.com/title/tt0118749'
    expect(@diggler.target).to eq 'http://www.imdb.com/title/tt0118749/'
  end

  describe '#get(*items)' do
    let(:diggler) { DirkDiggler.new 'http://www.imdb.com/title/tt0118749/' }

    it 'scrapes IMDB for the specified item(s)' do
      expect(diggler).to receive(:get_title).and_return true
      diggler.get :title

      expect(diggler).to receive(:get_year).and_return true
      expect(diggler).to receive(:get_runtime).and_return true
      diggler.get :year, :runtime
    end

    describe 'Shortcuts' do
      describe '#get(:info)' do
        it 'scrapes IMDB for general information about the movie (title, year, etc)' do
          items = %i[title aka year runtime rotten_tomatoes_url synopsis movie_poster_db_url poster_url]
          items.each { |item| expect(diggler).to receive("get_#{item}").and_return item.to_s }
          diggler.get :info
        end
      end

      describe '#get(:tags)' do
        it "scrapes IMDB for a movie's tags (genres, keywords, etc)" do
          items = %i[genres keywords languages countries]
          items.each { |item| expect(diggler).to receive("get_#{item}").and_return item.to_s }
          diggler.get :tags
        end
      end
    end
  end

  it 'returns the scraped data in a hash' do
    @data = { imdb_url: 'http://www.imdb.com/title/tt0118749/' }

    @diggler = DirkDiggler.new 'http://www.imdb.com/title/tt0118749/'
    expect(@diggler.data).to eq @data

    @new_data = { title: 'Boogie Nights', year: 1997, runtime: 155 }
    @new_data.each { |k, v| allow(@diggler).to receive(k).and_return v }

    @diggler.get :title, :year, :runtime
    expect(@diggler.data).to eq @data.merge(@new_data)
  end
end
