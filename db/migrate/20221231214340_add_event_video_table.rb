class AddEventVideoTable < ActiveRecord::Migration[7.0]
  def change
    create_table :event_videos do |t|
      t.integer :event_id
      t.integer :event_order
      t.integer :video_id
      t.index :event_id
      t.index :video_id
    end
    add_column :events, :videos_count, :integer
    add_column :videos, :events_count, :integer
  end
end
