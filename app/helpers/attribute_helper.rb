module AttributeHelper


  # In order to refactor the object#edit forms into a more manageable library of shared partials,
  # some helper methods became needed to adress meta-attributes such as
  # - duration
  #   - duration_hrs
  #   - duration_mins
  #   - etc.
  # - object.description (which is a pseudo-attribute display element, reliant upon:)
  #   - object.description_markup_type
  #   - object.description_markup_text



  ## Duration:
  #
  # These might not be needed here.
  # If the "duration" meta-attribute can have the same name across any additional objects,
  # then the partial can hard-code the individual attributes.


  def attribute_duration_hrs(attribute)
    attribute.to_s.concat('_hrs').to_sym
  end


  def attribute_duration_mins(attribute)
    attribute.to_s.concat('_mins').to_sym
  end


  def attribute_duration_secs(attribute)
    attribute.to_s.concat('_secs').to_sym
  end


  def attribute_duration_mils(attribute)
    attribute.to_s.concat('_mils').to_sym
  end



  ## ISRC:
  #
  # Currently only used by 'audio'. Already a very specific data label. Helper methods might not be needed.
  # :isrc_country_code
  # :isrc_registrant_code
  # :isrc_year_of_reference
  # :isrc_designation_code



  ## Parseables:
  #
  # Many objects have attributes that are extended text with an accomanying option to parse markup.
  # For example: picture.description_markup_type; picture.description_markup_text
  # In these cases, the text/parser combination is a property of a renderable psuedo-attribute presented as a display element: picture.description (so to speak)
  #


  def attribute_markup_type(attribute)
    attribute.to_s.concat('_markup_type').to_sym
  end


  def attribute_markup_text(attribute)
    attribute.to_s.concat('_markup_text').to_sym
  end


end
