class ArticleKeyword < ApplicationRecord

  scope :articles_released,         -> { joins(:articles).where('article.date_released <= ?', FindPublished.date_today) }
  scope :articles_public_joinable,  -> { joins(:articles).where(article: { visibility: ['public_indexable', 'public_joinable'] }) }
  scope :articles_published,        -> { articles_public_joinable.articles_released }

  scope :includes_article,  -> { includes(:article) }
  scope :includes_keyword,  -> { includes(:keyword) }

  belongs_to :article, counter_cache: :keywords_count
  belongs_to :keyword, counter_cache: :articles_count


  public

  ### article_id

  def does_have_order
    false
  end

  ### id

  ### keyword_id

end
