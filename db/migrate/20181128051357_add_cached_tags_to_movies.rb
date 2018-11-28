class AddCachedTagsToMovies < ActiveRecord::Migration[5.2]
  def change
    types = %w[country genre language]

    types.each do |type|
      add_column :movies, "cached_#{type}_list", :string
    end

    Movie.find_each do |movie|
      types.each do |type|
        cached_list = movie.send "#{type}_list"
        next if cached_list.blank?

        movie.update_column  "cached_#{type}_list", cached_list.join(', ')
      end
    end
  end
end
