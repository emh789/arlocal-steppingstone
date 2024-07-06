class EventDatetimeCleanup < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :datetime_year
    remove_column :events, :datetime_month
    remove_column :events, :datetime_day
    remove_column :events, :datetime_hour
    remove_column :events, :datetime_min
  end
end
