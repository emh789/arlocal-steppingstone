class SinglewordAutokeyword < ActiveRecord::Migration[7.1]
  def change
    rename_column :arlocal_settings, :admin_forms_auto_keyword_enabled, :admin_forms_autokeyword_enabled
    rename_column :arlocal_settings, :admin_forms_auto_keyword_id, :admin_forms_autokeyword_id  
  end
end
