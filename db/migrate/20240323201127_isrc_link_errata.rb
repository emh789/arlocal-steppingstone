class IsrcLinkErrata < ActiveRecord::Migration[7.1]
  def change
    rename_column :arlocal_settings, :admin_review_isrc_sorter_id, :admin_index_isrc_sorter_id
    add_column :links, :visibility, :string
    Link.all.each do |link|
      link.update!({visibility: 'unlisted'})
    end
  end
end
