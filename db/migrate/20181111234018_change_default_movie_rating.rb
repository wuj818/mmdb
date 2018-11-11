class ChangeDefaultMovieRating < ActiveRecord::Migration[5.2]
  def change
    change_column_default :movies, :rating, from: nil, to: 5
  end
end
