class RetireInfoPageLinks < ActiveRecord::Migration[7.1]
  def change
    drop_table :info_page_links
  end
end
