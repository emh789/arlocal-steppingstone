class RemovePublishedCounterCache < ActiveRecord::Migration[7.1]
  def change
    remove_column :albums, :audio_published_count
    remove_column :albums, :pictures_published_count
    remove_column :audio, :albums_published_count
    remove_column :audio, :events_published_count
    remove_column :events, :audio_published_count
    remove_column :events, :pictures_published_count
    remove_column :events, :videos_published_count
    remove_column :keywords, :albums_published_count
    remove_column :keywords, :articles_published_count
    remove_column :keywords, :audio_published_count
    remove_column :keywords, :events_published_count
    remove_column :keywords, :pictures_published_count
    remove_column :keywords, :videos_published_count
    remove_column :pictures, :albums_published_count
    remove_column :pictures, :events_published_count
    remove_column :pictures, :videos_published_count
    remove_column :videos, :events_published_count
    remove_column :videos, :pictures_published_count
  end
end
