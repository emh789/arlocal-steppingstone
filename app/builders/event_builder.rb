class EventBuilder

  attr_reader :event

  def initialize(**args)
    arlocal_settings = (ArlocalSettings === args[:arlocal_settings]) ? args[:arlocal_settings] : nil
    event = (Event === args[:event]) ? args[:event] : Event.new

    @arlocal_settings = arlocal_settings
    @event = event
  end


  protected

  def self.build(**args)
    builder = new(**args)
    yield(builder)
    builder.event
  end

  def self.build_with_defaults(**args)
    self.build(**args) do |b|
      b.assign_default_attributes
    end
  end

  def self.build_with_defaults_and_conditional_autokeyword(**args)
    self.build(**args) do |b|
      b.assign_default_attributes
      b.conditionally_build_autokeyword
    end
  end

  def self.create(event_params, **args)
    self.build(**args) do |b|
      b.assign_default_attributes
      b.assign_given_attributes(event_params)
    end
  end


  public

  def assign_default_attributes
    @event.assign_attributes(params_default)
  end

  def assign_given_attributes(event_params)
    @event.assign_attributes(event_params)
  end

  def conditionally_build_autokeyword
    if @arlocal_settings.admin_forms_new_will_have_autokeyword
      @event.event_keywords.build(keyword_id: @arlocal_settings.admin_forms_autokeyword_id)
    end
  end


  private

  def params_default
    {
      datetime_zone: Rails.application.config.time_zone,
      details_markup_type: 'plaintext',
      event_pictures_sort_method: 'cover_manual_asc',
      show_can_cycle_pictures: true,
      show_can_have_more_pictures_link: true,
      title_markup_type: 'string',
      visibility: 'admin_only'
    }
  end

end
