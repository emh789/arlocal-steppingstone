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
    @arlocal_settings = args[:arlocal_settings]
    @params = args[:params] ? args[:params] : {}
  end





  def all
    all_pictures
  end


  def index_admin
    case determine_filter_method_admin
    when 'datetime_asc'
      all_pictures.sort_by{ |p| p.datetime_effective_value }
    when 'datetime_desc'
      all_pictures.sort_by{ |p| p.datetime_effective_value }.reverse
    when 'filepath_asc'
      all_pictures.sort_by{ |p| [p.source_type.to_s, p.source_file_path.to_s] }
    when 'filepath_desc'
      all_pictures.sort_by{ |p| [p.source_type.to_s, p.source_file_path.to_s] }.reverse
    when 'title_asc'
      all_pictures.sort_by{ |p| p.title_without_markup.downcase }
    when 'title_desc'
      all_pictures.sort_by{ |p| p.title_without_markup.downcase }.reverse
    else
      all_pictures
    end
  end


  def index_admin_by_page
    Picture.paginate(collection: index_admin, limit: @params[:limit], page: @params[:page])
  end


  def index_public
    case determine_filter_method_public
    when 'datetime_asc'
      all_pictures.publicly_indexable.sort_by{ |p| p.datetime_effective_value }
    when 'datetime_desc'
      all_pictures.publicly_indexable.sort_by{ |p| p.datetime_effective_value }.reverse
    when 'filepath_asc'
      all_pictures.publicly_indexable.sort_by{ |p| [p.source_type.to_s, p.source_file_path.to_s] }
    when 'filepath_desc'
      all_pictures.publicly_indexable.sort_by{ |p| [p.source_type.to_s, p.source_file_path.to_s] }.reverse
    when 'title_asc'
      all_pictures.publicly_indexable.sort_by{ |p| p.title_without_markup.downcase }
    when 'title_desc'
      all_pictures.publicly_indexable.sort_by{ |p| p.title_without_markup.downcase }.reverse
    else
      all_pictures.publicly_indexable
    end
  end


  def index_public_by_page
    Picture.paginate(collection: index_public, limit: @params[:limit], page: @params[:page])
  end


  def neighborhood_admin(picture, distance: 1)
    Picture.neighborhood(picture, collection: index_admin, distance: distance)
  end


  def neighborhood_public(picture, distance: 1)
    Picture.neighborhood(picture, collection: index_public, distance: distance)
  end


  def options_for_select_admin
    case determine_filter_method_form_selectable
    when 'all_title_asc'
      all_pictures_for_select.sort_by{ |p| p.title_without_markup.downcase }
    when 'all_title_desc'
      all_pictures_for_select.sort_by{ |p| p.title_without_markup.downcase }.reverse
    when 'only_match_keywords'
      all_pictures_for_select.joins(:keywords).where(keywords: {id: keywords.map{|k| k.id} })
    when 'only_recent_10'
      all_pictures_for_select.order(:created_at).limit(10).sort_by{ |p| p.title_without_markup.downcase }
    when 'only_recent_20'
      all_pictures_for_select.order(:created_at).limit(20).sort_by{ |p| p.title_without_markup.downcase }
    when 'only_recent_40'
      all_pictures_for_select.order(:created_at).limit(40).sort_by{ |p| p.title_without_markup.downcase }
    else
      all_pictures_for_select
    end
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


  def determine_filter_method_admin
    if @params[:filter]
      @params[:filter].downcase
    else
      index_sorter_admin.id
    end
  end


  def determine_filter_method_form_selectable
    index_sorter_form_selectable.id
  end


  def determine_filter_method_public
    if @params[:filter]
      @params[:filter].downcase
    else
      index_sorter_public.id
    end
  end


  def index_sorter_admin
    SorterIndexAdminPictures.find(@arlocal_settings.admin_index_pictures_sort_method)
  end


  def index_sorter_form_selectable
    SorterFormSelectablePictures.find(@arlocal_settings.admin_forms_selectable_pictures_sort_method)
  end


  def index_sorter_public
    SorterIndexPublicPictures.find(@arlocal_settings.public_index_pictures_sort_method)
  end


end
