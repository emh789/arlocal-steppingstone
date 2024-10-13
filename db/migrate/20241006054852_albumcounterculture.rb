class Albumcounterculture < ActiveRecord::Migration[7.1]
  def change
    add_column :albums, :audio_count_cc, :integer, null: false, default: 0
    add_column :albums, :audio_published_count_cc, :integer, null: false, default: 0 
  end
end
