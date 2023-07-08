class ResourceVisibility < ActiveRecord::Migration[7.0]


  def up
    add_column :infopages, :visibility, :string
    resources.each do |resource|
      puts resource[0]
      add_column resource[0], :visibility, :string
      resource[1].all.each do |item|
        item.visibility = determine_visibility(item)
        puts item.title, item.visibility
        item.save
      end
      remove_column resource[0], :indexed
      remove_column resource[0], :published
    end
  end


  def down
    remove_column :infopages, :visibility
    resources.each do |resource|
      puts resource[0]
      add_column resource[0], :indexed, :string
      add_columm resource[0], :published, :string
      resource[1].all.each do |item|
        item.published = determine_published(item)
        item.indexed = determine_indexed(item)
        puts item.title, item.indexed, item.published
        item.save
      end
      remove_column resource[0], :visibility
    end
  end


  private

  def determine_indexed(item)
    if ['public'].include?(item.visibility)
      true
    end
  end


  def determine_published(item)
    if ['public','unlisted'].include?(item.visibility)
      true
    end
  end


  def determine_visibility(item)
    indexed = item.read_attribute(:indexed)
    published = item.read_attribute(:published)

    if (indexed == true) && (published == true)
      'public'
    elsif (indexed == false) && (published == true)
      'unlisted'
    elsif (indexed == false) && (published == false)
      'private'
    else
      'private'
    end
  end


  def resources
    [
      [:albums, Album],
      [:articles, Article],
      [:audio, Audio],
      [:events, Event],
      [:pictures, Picture],
      [:streams, Stream],
      [:videos, Video]
    ]
  end


end
