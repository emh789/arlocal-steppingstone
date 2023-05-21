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
    Audio.order_by_title_asc
  end



  public


  def initialize(**args)
    @arlocal_settings = args[:arlocal_settings]
    @params = args[:params] ? args[:params] : {}
  end


  def index_admin(arg = nil)
    case determine_filter_method_admin
    when 'datetime_asc'
      all_audio.order_by_date_released_asc.order_by_filepath_asc
    when 'datetime_desc'
      all_audio.order_by_date_released_desc.order_by_filepath_asc
    when 'filepath_asc'
      all_audio.order_by_filepath_asc
    when 'filepath_desc'
      all_audio.order_by_filepath_desc
    when 'isrc_asc'
      all_audio.order_by_isrc_asc
    when 'isrc_desc'
      all_audio.order_by_isrc_desc
    when 'title_asc'
      all_audio.order_by_title_asc
    when 'title_desc'
      all_audio.order_by_title_desc
    else
      all_audio
    end
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


  def determine_filter_method_admin
    if @params[:filter]
      @params[:filter].downcase
    else
      index_sorter_admin.symbol.to_s.downcase
    end
  end


  def determine_filter_method_public
    if @params[:filter]
      @params[:filter].downcase
    else
      index_sorter_public.symbol.to_s.downcase
    end
  end


  def index_sorter_admin
    SorterIndexAdminAudio.find(@arlocal_settings.admin_index_audio_sorter_id)
  end


  def index_sorter_public
    SorterIndexPublicAudio.find(@arlocal_settings.public_index_audio_sorter_id)
  end


end
