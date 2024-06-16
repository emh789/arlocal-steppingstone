class QueryArticles


  def initialize(**args)
    @params = args[:params]
  end


  protected

  def self.find(id)
    Article.friendly.find(id)
  end


  def self.find_admin(id)
    Article.friendly.find(id)
  end


  def self.find_public(id)
    Article.any_public_released_or_showable.friendly.find(id)
  end


  public

  def action_admin_show_neighborhood(article, distance: 1)
    Article.neighborhood(article, collection: Article.all, distance: distance)
  end


end
