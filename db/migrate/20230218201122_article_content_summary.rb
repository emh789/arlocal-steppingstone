class ArticleContentSummary < ActiveRecord::Migration[7.0]
  def change
    rename_column :articles, :parser_id, :content_parser_id
    rename_column :articles, :text_markup, :content_text_markup
    add_column :articles, :summary_parser_id, :integer
    add_column :articles, :summary_text_markup, :text
  end
end
