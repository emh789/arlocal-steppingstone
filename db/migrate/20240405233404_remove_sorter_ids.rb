class RemoveSorterIds < ActiveRecord::Migration[7.1]
  def change
    remove_column :albums, :album_pictures_sorter_id
    remove_column :arlocal_settings, :admin_forms_selectable_pictures_sorter_id
    remove_column :arlocal_settings, :admin_index_albums_sorter_id
    remove_column :arlocal_settings, :admin_index_audio_sorter_id
    remove_column :arlocal_settings, :admin_index_events_sorter_id
    remove_column :arlocal_settings, :admin_index_isrc_sorter_id
    remove_column :arlocal_settings, :admin_index_pictures_sorter_id
    remove_column :arlocal_settings, :admin_index_videos_sorter_id
    remove_column :arlocal_settings, :public_index_albums_sorter_id
    remove_column :arlocal_settings, :public_index_audio_sorter_id
    remove_column :arlocal_settings, :public_index_events_sorter_id
    remove_column :arlocal_settings, :public_index_pictures_sorter_id
    remove_column :arlocal_settings, :public_index_videos_sorter_id
    remove_column :events, :event_pictures_sorter_id
  end
end
