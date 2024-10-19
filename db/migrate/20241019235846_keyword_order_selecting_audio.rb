class KeywordOrderSelectingAudio < ActiveRecord::Migration[7.1]
  def change
    add_column :keywords, :order_selecting_audio, :integer
  end
end
