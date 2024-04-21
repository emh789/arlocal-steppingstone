class QueryVideos


  protected


  def self.find_admin(id)
    Video.friendly.find(id)
  end


  def self.find_public(id)
    Video.publicly_linkable.friendly.find(id)
  end


  def self.find_with_keyword(keyword)
    Video.joins(:keywords).where(keywords: {id: keyword.id})
  end


  def self.index_admin(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_admin
  end


  def self.index_public(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_public
  end


  def self.neighborhood_admin(video, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_admin(video)
  end


  def self.neighborhood_public(video, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_public(video)
  end


  def self.options_for_select_admin
    Video.select(:id, :title).sort_by{ |v| v.title.downcase }
  end



  public


  def initialize(**args)
    arlocal_settings = args[:arlocal_settings]
    params = args[:params] ? args[:params] : {}
    @sorter_admin = determine_sorter_admin(arlocal_settings, params)
    @sorter_public = determine_sorter_public(arlocal_settings, params)
  end


  def index_admin
    if @sorter_admin
      index_admin_sorted
    else
      index_admin_unsorted
    end
  end


  def index_admin_sorted
    @sorter_admin.sort all_videos
  end


  def index_admin_unsorted
    all_videos
  end


  def index_public
    if @sorter_public
      index_public_sorted
    else
      index_public_unsorted
    end
  end


  def index_public_sorted
    @sorter_public.sort all_videos.publicly_indexable
  end


  def index_public_unsorted
    all_videos.publicly_indexable
  end


  def neighborhood_admin(video, distance: 1)
    Video.neighborhood(video, collection: index_admin, distance: distance)
  end


  def neighborhood_public(video, distance: 1)
    collection = index_public
    if (Hash === collection)
      collection = collection.values.flatten!
    end
    Video.neighborhood(video, collection: collection, distance: distance)
  end


  private


  def all_videos
    Video.includes(:events, :keywords, {pictures: :source_uploaded_attachment})
  end


  def determine_sorter_admin(arlocal_settings, params)
    if params[:filter]
      SorterIndexAdminVideos.find(params[:filter])
    else
      SorterIndexAdminVideos.find(arlocal_settings.admin_index_videos_sort_method)
    end
  end


  def determine_sorter_public(arlocal_settings, params)
    if params[:filter]
      SorterIndexPublicVideos.find(params[:filter])
    else
      SorterIndexPublicVideos.find(arlocal_settings.public_index_videos_sort_method)
    end
  end


end
