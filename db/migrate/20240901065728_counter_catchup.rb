class CounterCatchup < ActiveRecord::Migration[7.1]
  def change
    add_column :articles,   :infopages_count,   :integer
    add_column :articles,   :keywords_count,    :integer
    add_column :infopages,  :articles_count,    :integer
    add_column :infopages,  :links_count,       :integer
    add_column :infopages,  :pictures_count,    :integer
    add_column :keywords,   :articles_count,    :integer
    add_column :links,      :infopages_count,   :integer
    add_column :pictures,   :infopages_count,   :integer
  end
end
