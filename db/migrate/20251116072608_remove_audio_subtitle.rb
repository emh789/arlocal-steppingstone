class RemoveAudioSubtitle < ActiveRecord::Migration[7.1]
  def change
    remove_column :audio, :subtitle
    remove_column :albums, :index_tracklist_audio_includes_subtitles
  end
end
