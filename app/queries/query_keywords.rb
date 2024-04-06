class QueryKeywords


  protected


  def self.find_admin(id)
    Keyword.friendly.find(id)
  end


  def self.index_admin
    new.index_admin
  end


  def self.neighborhood_admin(keyword)
    new.neighborhood_admin(keyword)
  end


  def self.options_for_select_admin
    Keyword.all.sort_by{ |k| k.title.downcase }
  end


  public


  def initialize(**args)
  end


  def index_admin
    all_keywords.sort_by{ |k| k.title.downcase }
  end


  def neighborhood_admin(keyword, distance: 1)
    Keyword.neighborhood(keyword, collection: index_admin, distance: distance)
  end


  private


  def all_keywords
    Keyword.includes(:albums, :audio, :events, :pictures, :videos)
  end


end
