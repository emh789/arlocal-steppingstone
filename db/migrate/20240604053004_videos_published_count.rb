class VideosPublishedCount < ActiveRecord::Migration[7.1]
  def change
    add_column :albums,   :audio_published_count,     :integer
    add_column :albums,   :pictures_published_count,  :integer

    add_column :audio,    :albums_published_count,    :integer
    add_column :audio,    :events_published_count,    :integer

    add_column :events,   :audio_published_count,     :integer
    add_column :events,   :pictures_published_count,  :integer
    add_column :events,   :videos_published_count,    :integer

    add_column :keywords, :albums_published_count,    :integer
    add_column :keywords, :articles_published_count,  :integer
    add_column :keywords, :audio_published_count,     :integer
    add_column :keywords, :events_published_count,    :integer
    add_column :keywords, :pictures_published_count,  :integer
    add_column :keywords, :videos_published_count,    :integer

    add_column :pictures, :albums_published_count,    :integer
    add_column :pictures, :events_published_count,    :integer
    add_column :pictures, :videos_published_count,    :integer

    add_column :videos,   :events_published_count,    :integer
    add_column :videos,   :pictures_published_count,  :integer

    add_column :events,   :date_announced,            :date

    create_table :article_keywords do |t|
      t.references :article
      t.references :keyword
    end

  end
end
