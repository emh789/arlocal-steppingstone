class Admin::ArticlesController < AdminController

  def create
    @article = ArticleBuilder.create(params_article_permitted)
    if @article.save
      flash[:notice] = 'Article was successfully created.'
      redirect_to edit_admin_article_path(@article)
    else
      @form_metadata = FormArticleMetadata.new
      flash[:notice] = 'Article could not be created'
      render 'new'
    end
  end

  def destroy
    @article = QueryArticles.find(params[:id])
    @article.destroy
    flash[:notice] = 'Article was destroyed.'
    redirect_to action: :index
  end

  def edit
    @article = QueryArticles.find(params[:id])
    @article_neighbors = QueryArticles.new(arlocal_settings: @arlocal_settings).action_admin_show_neighborhood(@article)
    @form_metadata = FormArticleMetadata.new(pane: params[:pane])
  end

  def index
    @articles = Article.all
  end

  def new
    @article = ArticleBuilder.build_with_defaults_and_conditional_autokeyword(@arlocal_settings)
    @form_metadata = FormArticleMetadata.new
  end

  def show
    @article = QueryArticles.find(params[:id])
    @article_neighbors = QueryArticles.new(arlocal_settings: @arlocal_settings).action_admin_show_neighborhood(@article)
  end

  def update
    @article = QueryArticles.find(params[:id])
    if @article.update(params_article_permitted)
      flash[:notice] = 'Article was successfully created.'
      redirect_to edit_admin_article_path(@article)
    else
      @form_metadata = FormArticleMetadata.new(pane: params[:pane])
      flash[:notice] = 'Article could not be created'
      render 'edit'
    end
  end


  private

  def params_article_permitted
    params.require(:article).permit(
      :author,
      :content_markup_type,
      :content_markup_text,
      :copyright_markup_type,
      :copyright_markup_text,
      :date_released,
      :summary_markup_type,
      :summary_markup_text,
      :title,
      :visibility,
      article_keywords_attributes: [
        :id,
        :keyword_id,
        :_destroy
      ]
    )
  end

end
