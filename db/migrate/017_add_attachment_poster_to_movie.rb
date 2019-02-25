class AddAttachmentPosterToMovie < ActiveRecord::Migration[5.2]
  def self.up
    add_column :movies, :poster_file_name, :string
    add_column :movies, :poster_url, :string
    add_column :movies, :poster_content_type, :string
    add_column :movies, :poster_file_size, :integer
    add_column :movies, :poster_updated_at, :datetime
  end

  def self.down
    remove_column :movies, :poster_file_name
    remove_column :movies, :poster_url
    remove_column :movies, :poster_content_type
    remove_column :movies, :poster_file_size
    remove_column :movies, :poster_updated_at
  end
end
