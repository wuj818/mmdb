require 'rails_helper'

describe DirkDiggler do
  before { Mechanize.stub new: instance_double('Mechanize', 'user_agent=' => true, get: true) }

  it 'requires an IMDB url' do
    lambda { DirkDiggler.new }.should raise_error ArgumentError
  end

  it 'automatically removes any url params' do
    @diggler = DirkDiggler.new 'http://www.imdb.com/title/tt0118749/?ref_=nv_sr_1'
    @diggler.target.should == 'http://www.imdb.com/title/tt0118749/'
  end

  it 'automatically appends a slash to the IMDB url if needed' do
    @diggler = DirkDiggler.new 'http://www.imdb.com/title/tt0118749/'
    @diggler.target.should == 'http://www.imdb.com/title/tt0118749/'

    @diggler = DirkDiggler.new 'http://www.imdb.com/title/tt0118749'
    @diggler.target.should == 'http://www.imdb.com/title/tt0118749/'
  end

  describe '#get(*items)' do
    let(:diggler) { DirkDiggler.new 'http://www.imdb.com/title/tt0118749/' }

    it 'scrapes IMDB for the specified item(s)' do
      diggler.should_receive(:get_title) { true }
      diggler.get :title
      diggler.should respond_to

      diggler.should_receive(:get_year) { true }
      diggler.should_receive(:get_runtime) { true }
      diggler.get :year, :runtime
    end

    describe 'Shortcuts' do
      describe '#get(:info)' do
        it 'scrapes IMDB for general information about the movie (title, year, etc)' do
          items = [:title, :aka, :year, :runtime]
          items.each { |item| diggler.should_receive("get_#{item.to_s}") { true } }
          diggler.get :info
        end
      end

      describe '#get(:tags)' do
        it "scrapes IMDB for a movie's tags (genres, keywords, etc)" do
          items = [:genres, :keywords, :languages, :countries]
          items.each { |item| diggler.should_receive("get_#{item.to_s}") { true } }
          diggler.get :tags
        end
      end
    end
  end

  it 'returns the scraped data in a hash' do
    @data = { imdb_url: 'http://www.imdb.com/title/tt0118749/' }

    @diggler = DirkDiggler.new 'http://www.imdb.com/title/tt0118749/'
    @diggler.data.should == @data

    @new_data = { title: 'Boogie Nights', year: 1997, runtime: 155 }
    @new_data.each { |k, v| @diggler.stub k => v }

    @diggler.get :title, :year, :runtime
    @diggler.data.should == @data.merge(@new_data)
  end
end
