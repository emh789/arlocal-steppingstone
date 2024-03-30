class KeywordCanSelectAudio < ActiveRecord::Migration[7.1]
  def change
    add_column :keywords, :can_select_audio, :boolean
  end
end
