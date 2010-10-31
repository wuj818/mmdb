# encoding: utf-8
require 'spec_helper'

describe String do
  describe '#to_permalink' do
    movies = {
      # easy case
      'Oldboy' => 'oldboy',
      # two words
      'Boogie Nights' => 'boogie-nights',
      # colon
      'Anchorman: The Legend of Ron Burgundy' => 'anchorman-the-legend-of-ron-burgundy',
      # periods and colon
      'J.S.A.: Joint Security Area' => 'jsa-joint-security-area',
      # apostrophe
      "The Devil's Backbone" => 'the-devils-backbone',
      # ampersand
      "Bill & Ted's Excellent Adventure" => 'bill-and-teds-excellent-adventure',
      # umlauts
      'Y tu mamá también' => 'y-tu-mama-tambien',
      # other chars
      'WALL·E' => 'wall-e'
    }

    it 'returns a nicely formatted permalink with dashes' do
      movies.each { |title, permalink| title.to_permalink.should == permalink }
    end
  end

  describe '#to_sort_column' do
    movies = {
      'A Very Long Engagement' => 'very long engagement',
      'An Andalusian Dog' => 'andalusian dog',
      'The Game' => 'game'
    }

    it 'returns a nicely formatted sort value without unnecessary words' do
      movies.each { |column, sort_column| column.to_sort_column.should == sort_column }
    end
  end
end
