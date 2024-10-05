module MarkupTypeFixer

  module_function

  def inline
    resource_classes.each do |resource_class|
      resource_class.all.each do |resource|
        old_markup_type_string = resource.attributes.select { |a| (a =~ /markup_type/) && (resource.read_attribute(a) == "string") }
        new_markup_type_inline = old_markup_type_string.transform_values { |v| 'string' }
        resource.update(new_markup_type_inline)
      end
    end
  end

  def resource_classes
    [ Album, ArlocalSettings, Article, Audio, Event, Link, Picture, Stream, Video ]
  end

end
