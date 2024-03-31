module MarkupParserUtils
  
  
  def reset_markup_types(resource, new_value)
    case new_value
    when Integer
      new_markup_type = new_value
    when String
      new_markup_type = new_value.to_i
    when Symbol
      new_markup_type = MarkupParser.find_by_symbol(new_value).id
    else
      new_markup_type = new_value.to_i
    end
    
    new_attributes = {}
    resource_markup_types = resource.attributes.select { |k,v| k =~ /markup_type\z/ }
    resource_markup_types.each_pair do |k,v|
      new_attributes[k] = new_markup_type
    end
    
    resource.update(new_attributes)
  end
    
    
end