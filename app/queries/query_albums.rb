class QueryAlbums


  protected

  def self.find_admin(id)
    Album.include_everything.friendly.find(id)
  end

  def self.find_public(id)
    Album.any_public_released_or_showable.include_everything.friendly.find(id)
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
    arlocal_settings = args[:arlocal_settings]
    params = args[:params] ? args[:params] : {}
    @sorter_admin = determine_sorter_admin(arlocal_settings, params)
    @sorter_public = determine_sorter_public(arlocal_settings, params)
  end


  def index_admin
    @sorter_admin ? index_admin_sorted : index_admin_unsorted
  end

  def index_admin_sorted
    @sorter_admin.sort index_admin_unsorted
  end

  def index_admin_unsorted
    Album.all.include_everything
  end

  def index_public
    @sorter_public ? index_public_sorted : index_public_unsorted
  end

  def index_public_sorted
    @sorter_public.sort index_public_unsorted
  end

  def index_public_unsorted
    Album.all_public_indexable.include_everything
  end

  def neighborhood_admin(album, distance: 1)
    Album.neighborhood(album, collection: index_admin, distance: distance)
  end

  def neighborhood_public(album, distance: 1)
    Album.neighborhood(album, collection: index_public, distance: distance)
  end


  private

  def determine_sorter_admin(arlocal_settings, params)
    if params[:filter]
      SorterIndexAdminAlbums.find(params[:filter])
    else
      SorterIndexAdminAlbums.find(arlocal_settings.admin_index_albums_sort_method)
    end
  end

  def determine_sorter_public(arlocal_settings, params)
    if params[:filter]
      SorterIndexPublicAlbums.find(params[:filter])
    else
      SorterIndexPublicAlbums.find(arlocal_settings.public_index_albums_sort_method)
    end
  end


end
