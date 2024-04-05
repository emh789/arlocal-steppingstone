class QueryAlbums


  protected


  def self.find_admin(id)
    Album.friendly.find(id)
  end


  def self.find_public(id)
    Album.publicly_linkable.friendly.find(id)
  end


  def self.index_admin(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_admin
  end


  def self.index_public(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_public
  end


  def self.neighborhood_admin(album, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_admin(album)
  end


  def self.neighborhood_public(album, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_public(album)
  end


  def self.options_for_select_admin
    Album.select(:id, :title).sort_by{ |a| a.title.downcase }
  end


  public


  def initialize(**args)
    @arlocal_settings = args[:arlocal_settings]
    @params = args[:params] ? args[:params] : {}
  end


  def index_admin
    case determine_filter_method_admin
    when 'datetime_asc'
      all_albums.sort_by{ |a| a.date_released }
    when 'datetime_desc'
      all_albums.sort_by{ |a| a.date_released }.reverse
    when 'title_asc'
      all_albums.sort_by{ |a| a.title.downcase }
    when 'title_desc'
      all_albums.sort_by{ |a| a.title.downcase }.reverse
    else
      all_albums
    end
  end


  def index_public
    case determine_filter_method_public
    when 'datetime_asc'
      all_albums.publicly_indexable.sort_by{ |a| a.date_released }
    when 'datetime_desc'
      all_albums.publicly_indexable.sort_by{ |a| a.date_released }.reverse
    when 'title_asc'
      all_albums.publicly_indexable.sort_by{ |a| a.title.downcase }
    when 'title_desc'
      all_albums.publicly_indexable.sort_by{ |a| a.title.downcase }.reverse
    else
      all_albums.publicly_indexable
    end
  end


  def neighborhood_admin(album, distance: 1)
    Album.neighborhood(album, collection: index_admin, distance: distance)
  end


  def neighborhood_public(album, distance: 1)
    Album.neighborhood(album, collection: index_public, distance: distance)
  end


  private


  def all_albums
    Album.includes({ audio: :source_uploaded_attachment }, :keywords, { pictures: :source_uploaded_attachment })
  end


  def determine_filter_method_admin
    if @params[:filter]
      @params[:filter].downcase
    else
      index_sorter_admin.id
    end
  end


  def determine_filter_method_public
    if @params[:filter]
      @params[:filter].downcase
    else
      index_sorter_public.id
    end
  end


  def index_sorter_admin
    SorterIndexAdminAlbums.find(@arlocal_settings.admin_index_albums_sort_method)
  end


  def index_sorter_public
    SorterIndexPublicAlbums.find(@arlocal_settings.public_index_albums_sort_method)
  end


end
