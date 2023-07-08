class ResourceVisibility < ActiveRecord::Migration[7.0]


  def up
    add_column :infopages, :visibility, :string
    applicable_resources.each do |resource|
      say resource[:name]
      add_column resource[:symbol], :visibility, :string
      resource[:object].all.each do |item|
        item.visibility = determine_visibility(item)
        say ({id: item.id, title: item.title, visibility: item.visibility})
        item.save
      end
      remove_column resource[:symbol], :indexed
      remove_column resource[:symbol], :published
    end
  end


  def down
    remove_column :infopages, :visibility
    applicable_resources.each do |resource|
      say resource[:name]
      add_column resource[:symbol], :indexed, :string
      add_columm resource[:symbol], :published, :string
      resource[:object].all.each do |item|
        item.published = determine_published(item)
        item.indexed = determine_indexed(item)
        say ({id: item.id, title: item.title, indexed: item.indexed, published: item.published})
        item.save
      end
      remove_column resource[:symbol], :visibility
    end
  end


  private


  def applicable_resources
    [
      { name: 'Albums',   object: Album,   symbol: :albums   },
      { name: 'Articles', object: Article, symbol: :articles },
      { name: 'Audio',    object: Audio,   symbol: :audio    },
      { name: 'Events',   object: Event,   symbol: :events   },
      { name: 'Pictures', object: Picture, symbol: :pictures },
      { name: 'Streams',  object: Stream,  symbol: :streams  },
      { name: 'Videos',   object: Video,   symbol: :videos   },
    ]
  end


  def determine_indexed(item)
    if ['public'].include?(item.read_attribute(:visibility))
      true
    end
  end


  def determine_published(item)
    if ['public','unlisted'].include?(item.read_attribute(:visibility))
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


end
