class QueryPictures


  protected


  def self.find_admin(id)
    Picture.friendly.find(id)
  end


  def self.find_public(id)
    Picture.publicly_linkable.friendly.find(id)
  end


  def self.find_with_keyword(keyword)
    Picture.joins(:keywords).where(keywords: {id: keyword.id})
  end


  def self.index_admin(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_admin
  end


  def self.index_admin_by_page(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_admin_by_page
  end


  def self.index_public(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_public
  end


  def self.index_public_by_page(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_public_by_page
  end


  def self.neighborhood_admin(picture, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_admin(picture)
  end


  def self.neighborhood_public(picture, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_public(picture)
  end



  def self.options_for_select_admin(arlocal_settings)
    new(arlocal_settings: arlocal_settings).options_for_select_admin
  end


  def self.options_for_select_admin_with_nil(arlocal_settings)
    new(arlocal_settings: arlocal_settings).options_for_select_admin_with_nil
  end



  public


  def initialize(**args)
    arlocal_settings = args[:arlocal_settings]
    params = args[:params] ? args[:params] : {}

    @sorter_admin_index = determine_sorter_admin_index(arlocal_settings, params)
    @sorter_admin_form_selectable = determine_sorter_admin_form_selectable(arlocal_settings)
    @sorter_public_index = determine_sorter_public_index(arlocal_settings, params)
  end


  def index_admin
    if @sorter_admin_index
      index_admin_sorted
    else
      index_admin_unsorted
    end
  end


  def index_admin_by_page
    Picture.paginate(collection: index_admin, limit: @params[:limit], page: @params[:page])
  end


  def index_admin_sorted
    @sorter_admin_index.sort all_pictures
  end


  def index_admin_unsorted
    all_pictures
  end


  def index_public
    if @sorter_public_index
      index_public_sorted
    else
      index_public_unsorted
    end
  end


  def index_public_by_page
    Picture.paginate(collection: index_public, limit: @params[:limit], page: @params[:page])
  end


  def index_public_sorted
    @sorter_public_index.sort all_pictures.publicly_indexable
  end


  def index_public_unsorted
    all_pictures.publicly_indexable
  end


  def neighborhood_admin(picture, distance: 1)
    Picture.neighborhood(picture, collection: index_admin, distance: distance)
  end


  def neighborhood_public(picture, distance: 1)
    Picture.neighborhood(picture, collection: index_public, distance: distance)
  end


  def options_for_select_admin
    @sorter_admin_form_selectable.sort all_pictures_for_select
  end


  def options_for_select_admin_with_nil
    [PictureBuilder.nil_picture, options_for_select_admin].flatten
  end



  private


  def all_pictures
    Picture.with_attached_source_uploaded
  end


  def all_pictures_for_select
    Picture.with_attached_source_uploaded.select(:id, :source_imported_file_path, :source_type, :title_without_markup)
  end


  def determine_sorter_admin_index(arlocal_settings, params)
    if params[:filter]
      SorterIndexAdminPictures.find(params[:filter])
    else
      SorterIndexAdminPictures.find(arlocal_settings.admin_index_pictures_sort_method)
    end
  end


  def determine_sorter_admin_form_selectable(arlocal_settings)
    SorterFormSelectablePictures.find(arlocal_settings.admin_forms_selectable_pictures_sort_method)
  end


  def determine_sorter_public_index(arlocal_settings, params)
    if params[:filter]
      SorterIndexPublicPictures.find(params[:filter])
    else
      SorterIndexPublicPictures.find(arlocal_settings.public_index_pictures_sort_method)
    end
  end


end
