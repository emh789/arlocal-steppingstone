class RemoveCounterCulture < ActiveRecord::Migration[7.1]
  def change
    remove_column :albums, :audio_count_cc
    remove_column :albums, :audio_published_count_cc
  end
end
