class SettingsHomepageTarget < ActiveRecord::Migration[7.1]
  def change
    add_column :arlocal_settings, :public_homepage_target, :string
  end
end
