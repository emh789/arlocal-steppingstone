module MoveSortIdToMethod

  def self.change
    Album.all.each do |album|
      album.album_pictures_sort_method = SorterAlbumPictures.find(album.album_pictures_sorter_id).symbol
      album.save!
    end
    arlocal_settings = ArlocalSettings.first
    arlocal_settings.update!({
      admin_forms_selectable_pictures_sort_method: SorterFormSelectablePictures.find(arlocal_settings.admin_forms_selectable_pictures_sorter_id).symbol,
      admin_index_albums_sort_method: SorterIndexAdminAlbums.find(arlocal_settings.admin_index_albums_sorter_id).symbol,
      admin_index_audio_sort_method: SorterIndexAdminAudio.find(arlocal_settings.admin_index_audio_sorter_id).symbol,
      admin_index_events_sort_method: SorterIndexAdminEvents.find(arlocal_settings.admin_index_events_sorter_id).symbol,
      admin_index_isrc_sort_method: SorterIndexAdminIsrc.find(arlocal_settings.admin_index_isrc_sorter_id).symbol,
      admin_index_pictures_sort_method: SorterIndexAdminPictures.find(arlocal_settings.admin_index_pictures_sorter_id).symbol,
      admin_index_videos_sort_method: SorterIndexAdminVideos.find(arlocal_settings.admin_index_videos_sorter_id).symbol,
      public_index_albums_sort_method: SorterIndexPublicAlbums.find(arlocal_settings.public_index_albums_sorter_id).symbol,
      public_index_audio_sort_method: SorterIndexPublicAudio.find(arlocal_settings.public_index_audio_sorter_id).symbol,
      public_index_events_sort_method: SorterIndexPublicEvents.find(arlocal_settings.public_index_events_sorter_id).symbol,
      public_index_pictures_sort_method: SorterIndexPublicPictures.find(arlocal_settings.public_index_pictures_sorter_id).symbol,
      public_index_videos_sort_method:  SorterIndexPublicVideos.find(arlocal_settings.public_index_videos_sorter_id).symbol,
    })
    Event.all.each do |event|
      event.event_pictures_sort_method = SorterEventPictures.find(event.event_pictures_sorter_id).symbol
      event.save!
    end

  end
end
