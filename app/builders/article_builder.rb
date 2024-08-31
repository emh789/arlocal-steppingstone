class ArticleBuilder

  attr_reader :article

  def initialize
    @article = Article.new
  end


  protected

  def self.build
    builder = new
    yield(builder)
    builder.article
  end

  def self.build_with_defaults(arlocal_settings)
    self.build do |b|
      b.assign_default_attributes
    end
  end

  def self.build_with_defaults_and_conditional_autokeyword(arlocal_settings)
    self.build do |b|
      b.assign_default_attributes
      b.conditionally_build_autokeyword(arlocal_settings)
    end
  end

  def self.create(article_params)
    self.build do |b|
      b.assign_default_attributes
      b.assign_given_attributes(article_params)
    end
  end


  public

  def assign_default_attributes
    @article.assign_attributes(params_default)
  end

  def assign_given_attributes(article_params)
    @article.assign_attributes(article_params)
  end

  def conditionally_build_autokeyword(arlocal_settings)
    if arlocal_settings.admin_forms_new_will_have_autokeyword
      @article.article_keywords.build(keyword_id: arlocal_settings.admin_forms_autokeyword_id)
    end
  end


  private

  def params_default
    {
      content_markup_type: 'plaintext',
      copyright_markup_type: 'string',
      visibility: 'admin_only'
    }
  end

end
