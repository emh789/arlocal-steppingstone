class QueryEvents


  protected


  def self.find_admin(id)
    Event.friendly.find(id)
  end


  def self.find_public(id)
    Event.publicly_linkable.friendly.find(id)
  end


  def self.index_admin(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_admin
  end


  def self.index_public(arlocal_settings, params)
    new(arlocal_settings: arlocal_settings, params: params).index_public
  end


  def self.neighborhood_admin(event, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_admin(event)
  end


  def self.neighborhood_public(event, arlocal_settings)
    new(arlocal_settings: arlocal_settings).neighborhood_public(event)
  end


  def self.options_for_select_admin
    Event.select(:id, :datetime_utc, Event.datetime_array_attrs, :title_without_markup).sort_by{ |e| e.datetime_utc }
  end


  public


  def initialize(**args)
    @arlocal_settings = args[:arlocal_settings]
    @params = args[:params] ? args[:params] : {}
  end


  def index_admin
    case determine_filter_method_admin
    when 'datetime_asc'
      all_events.sort_by{ |e| e.datetime_utc }
    when 'datetime_desc'
      all_events.sort_by{ |e| e.datetime_utc }.reverse
    when 'only_future'
      all_events.only_future.sort_by{ |e| e.datetime_utc }
    when 'only_past'
      all_events.only_past.sort_by{ |e| e.datetime_utc }.reverse
    when 'title_asc'
      all_events.sort_by{ |e| e.title.downcase }
    when 'title_desc'
      all_events.sort_by{ |e| e.title.downcase }.reverse
    else
      all_events
    end
  end


  def index_public
    case determine_filter_method_public
    when 'all'
      all_events.publicly_indexable.sort_by{ |e| e.datetime_utc }
    when 'future'
      all_events.publicly_indexable.only_future.sort_by{ |e| e.datetime_utc }
    when 'past'
      all_events.publicly_indexable.only_past.sort_by{ |e| e.datetime_utc }.reverse
    when 'upcoming'
      all_events.publicly_indexable.only_future_near.sort_by{ |e| e.datetime_utc }
    when 'with_audio'
      all_events.publicly_indexable.only_with_audio.sort_by{ |e| e.datetime_utc }.reverse
    else
      all_events.publicly_indexable.sort_by{ |e| e.datetime_utc }
    end
  end


  def neighborhood_admin(event, distance: 1)
    Event.neighborhood(event, collection: index_admin, distance: distance)
  end


  def neighborhood_public(event, distance: 1)
    Event.neighborhood(event, collection: index_public, distance: distance)
  end


  private


  def all_events
    Event.includes({ audio: :source_uploaded_attachment }, :keywords, { pictures: :source_uploaded_attachment }, { videos: :source_uploaded_attachment })
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
    SorterIndexAdminEvents.find(@arlocal_settings.admin_index_events_sort_method)
  end


  def index_sorter_public
    SorterIndexPublicEvents.find(@arlocal_settings.public_index_events_sort_method)
  end


end
