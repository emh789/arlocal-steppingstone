class PictureDatetimeZone < ActiveRecord::Migration[7.1]
  def change
    add_column :pictures, :datetime_from_manual_entry, :datetime
    change_column :pictures, :datetime_from_manual_entry_zone, :string
  end
end
