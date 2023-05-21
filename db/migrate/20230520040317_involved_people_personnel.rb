class InvolvedPeoplePersonnel < ActiveRecord::Migration[7.0]
  def change
    rename_column :albums, :involved_people_parser_id, :personnel_parser_id
    rename_column :albums, :involved_people_text_markup, :personnel_text_markup
    rename_column :audio, :involved_people_parser_id, :personnel_parser_id
    rename_column :audio, :involved_people_text_markup, :personnel_text_markup
    rename_column :videos, :involved_people_parser_id, :personnel_parser_id
    rename_column :videos, :involved_people_text_markup, :personnel_text_markup
  end
end
