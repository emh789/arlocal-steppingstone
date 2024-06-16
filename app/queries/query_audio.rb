class QueryAudio


  protected

  def self.find_admin(id)
    Audio.all.include_everything.friendly.find(id)
  end

  def self.find_admin_with_keyword(keyword)
    Audio.any_with_keyword(keyword).include_everything
  end

  def self.find_public(id)
    Audio.publicly_linkable.include_everything.friendly.find(id)
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
    @sorter_admin.sort index_admin_unsorted
  end

  def index_admin_unsorted
    Audio.all.include_everything
  end

  def index_public
    Audio.any_public_released_indexable.include_everything
  end

  def neighborhood_admin(audio, distance: 1)
    Audio.neighborhood(audio, collection: index_admin, distance: distance)
  end

  def neighborhood_public(audio, distance: 1)
    Audio.neighborhood(audio, collection: index_public, distance: distance)
  end


  private

  def determine_sorter_admin(arlocal_settings, params)
    if params[:filter]
      SorterIndexAdminAudio.find(params[:filter])
    else
      SorterIndexAdminAudio.find(arlocal_settings.admin_index_audio_sort_method)
    end
  end

  def determine_sorter_public(arlocal_settings, params)
    if params[:filter]
      SorterIndexPublicAudio.find(params[:filter])
    else
      SorterIndexPublicAudio.find(arlocal_settings.public_index_audio_sort_method)
    end
  end


end
