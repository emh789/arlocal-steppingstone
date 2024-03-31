class ParserIdToMarkupType
  def self.change
    [ Album, Article, Audio, Event, Link, Picture, Stream, Video ].each do |resource|
      resource.attribute_names.select{ |attr| attr.match('_markup_type') }.each do |attribute_name|
        resource.all.each { |item| ParserIdToMarkupType.operate(item, attribute_name)}
      end
    end
    arlocal_settings = ArlocalSettings.first
    ParserIdToMarkupType.operate(arlocal_settings, 'marquee_markup_type')
  end


  def self.operate(item, attribute_name)
    markup_type = ''
    markup_id = item.read_attribute(attribute_name).to_s
    case markup_id
    when '0'
      markup_type = 'string'
    when '3'
      markup_type = 'markdown'
    when '4'
      markup_type = 'plaintext'
    else
      markup_type = 'plaintext'
    end
    puts "#{item.title} | #{attribute_name} | #{markup_id} | #{markup_type}"
    item.update!({attribute_name => markup_type})
  end
end
