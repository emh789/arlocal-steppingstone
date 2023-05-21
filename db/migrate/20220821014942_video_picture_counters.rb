class VideoPictureCounters < ActiveRecord::Migration[7.0]
  def change
    add_column :pictures, :videos_count, :integer
    add_column :videos, :pictures_count, :integer
  end
end
