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
    @sorter_admin.sort all_events
  end


  def index_admin_unsorted
    all_events
  end


  def index_public
    if @sorter_public
      index_public_sorted
    else
      index_public_unsorted
    end
  end


  def index_public_sorted
    @sorter_public.sort all_events.publicly_indexable
  end


  def index_public_unsorted
    all_events.publicly_indexable
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


  def determine_sorter_admin(arlocal_settings, params)
    if params[:filter]
      SorterIndexAdminEvents.find(params[:filter])
    else
      SorterIndexAdminEvents.find(arlocal_settings.admin_index_events_sort_method)
    end
  end


  def determine_sorter_public(arlocal_settings, params)
    if params[:filter]
      SorterIndexPublicEvents.find(params[:filter])
    else
      SorterIndexPublicEvents.find(arlocal_settings.public_index_events_sort_method)
    end
  end


end
