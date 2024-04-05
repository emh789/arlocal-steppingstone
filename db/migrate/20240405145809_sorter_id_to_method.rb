class SorterIdToMethod < ActiveRecord::Migration[7.1]
  def change

    change_table :albums do |t|
      t.string :album_pictures_sort_method
    end

    change_table :arlocal_settings do |t|
      t.string :admin_forms_selectable_pictures_sort_method
      t.string :admin_index_albums_sort_method
      t.string :admin_index_audio_sort_method
      t.string :admin_index_events_sort_method
      t.string :admin_index_isrc_sort_method
      t.string :admin_index_pictures_sort_method
      t.string :admin_index_videos_sort_method
      t.string :public_index_albums_sort_method
      t.string :public_index_audio_sort_method
      t.string :public_index_events_sort_method
      t.string :public_index_pictures_sort_method
      t.string :public_index_videos_sort_method
    end

    change_table :events do |t|
      t.string :event_pictures_sort_method, :string
    end

  end
end
