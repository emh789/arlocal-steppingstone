class QueryAudio


  protected


  def self.find_admin(id)
    Audio.friendly.find(id)
  end


  def self.find_public(id)
    Audio.publicly_linkable.friendly.find(id)
  end


  def self.find_with_keyword(keyword)
    Audio.joins(:keywords).where(keywords: {id: keyword.id})
  end


  def self.index_admin(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_admin
  end


  def self.index_public(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_public
  end


  def self.neighborhood_admin(audio, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_admin(audio)
  end


  def self.neighborhood_public(audio, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_public(audio)
  end


  def self.options_for_select_admin
    Audio.select(:id, :title, :subtitle).sort_by{ |a| a.full_title.downcase }
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
    @sorter_admin.sort all_audio
  end


  def index_admin_unsorted
    all_audio
  end



  def index_public
    all_audio.publicly_indexable
  end


  def neighborhood_admin(audio, distance: 1)
    Audio.neighborhood(audio, collection: index_admin, distance: distance)
  end


  def neighborhood_public(audio, distance: 1)
    Audio.neighborhood(audio, collection: index_public, distance: distance)
  end



  private


  def all_audio
    Audio.all.with_attached_source_uploaded
  end


  def determine_sorter_admin(arlocal_settings, params)
    if params[:filter]
      SorterIndexAdminAudio.find(params[:filter])
    else
      SorterIndexAdminAudio.find(arlocal_settings.admin_index_albums_sort_method)
    end
  end


  def determine_sorter_public(arlocal_settings, params)
    if params[:filter]
      SorterIndexPublicAudio.find(params[:filter])
    else
      SorterIndexPublicAudio.find(arlocal_settings.public_index_albums_sort_method)
    end
  end


end
