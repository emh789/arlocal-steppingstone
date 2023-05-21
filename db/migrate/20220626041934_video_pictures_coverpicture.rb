class VideoPicturesCoverpicture < ActiveRecord::Migration[7.0]
  def change
    add_column :video_pictures, :is_coverpicture, :boolean
    add_column :video_pictures, :video_order, :integer
  end
end
