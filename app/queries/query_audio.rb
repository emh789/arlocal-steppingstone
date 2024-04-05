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
    @arlocal_settings = args[:arlocal_settings]
    @params = args[:params] ? args[:params] : {}
  end


  def index_admin(arg = nil)
    case determine_filter_method_admin
    when 'datetime_asc'
      all_audio.sort_by{ |a| a.title.downcase }.sort_by{ |a| a.date_released }
    when 'datetime_desc'
      all_audio.sort_by{ |a| a.title.downcase }.reverse.sort_by{ |a| a.date_released }.reverse
    when 'filepath_asc'
      all_audio.sort_by{ |a| a.source_file_path }
    when 'filepath_desc'
      all_audio.sort_by{ |a| a.source_file_path }.reverse
    when 'isrc_asc'
      all_audio.sort_by{ |a| [a.isrc_country_code.to_s, a.isrc_registrant_code.to_s, a.isrc_year_of_reference.to_s, a.isrc_designation_code.to_s] }
    when 'isrc_desc'
      all_audio.sort_by{ |a| [a.isrc_country_code.to_s, a.isrc_registrant_code.to_s, a.isrc_year_of_reference.to_s, a.isrc_designation_code.to_s] }.reverse
    when 'title_asc'
      all_audio.sort_by{ |a| a.title.downcase }
    when 'title_desc'
      all_audio.sort_by{ |a| a.title.downcase }.reverse
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
    SorterIndexAdminAudio.find(@arlocal_settings.admin_index_audio_sort_method)
  end


  def index_sorter_public
    SorterIndexPublicAudio.find(@arlocal_settings.public_index_audio_sort_method)
  end


end
