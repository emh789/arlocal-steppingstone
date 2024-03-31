class ParserIdToType < ActiveRecord::Migration[7.1]
  def change
    [ Album, Article, Audio, Event, Link, Picture, Stream, Video ].each{ |resource| operation(resource) }
    rename_column :arlocal_settings, :marquee_parser_id, :marquee_markup_type
    change_column :arlocal_settings, :marquee_markup_type, :string
    rename_column :arlocal_settings, :marquee_text_markup, :marquee_markup_text
  end


  def operation(resource)
    resource.attribute_names.select{ |attr| attr.match('_parser_id') }.each do |name|
      table = resource.to_s.downcase.pluralize
      column_old = name
      column_new = name.gsub('parser_id','markup_type')
      rename_column table, column_old, column_new
      change_column table, column_new, :string
    end
    resource.attribute_names.select{ |attr| attr.match('_text_markup') }.each do |name|
      table = resource.to_s.downcase.pluralize
      column_old = name
      column_new = name.gsub('text_markup','markup_text')
      rename_column table, column_old, column_new
    end
  end

end
