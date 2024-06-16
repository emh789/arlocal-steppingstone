module FindPublished

  module_function

  def date_today
    Date.new(
      *(Time.
        now.
        strftime('%Y %m %d').
        split(' ').
        map { |i| i.to_i }
      )
    )
  end



  def revisibility
    [ Album, Article, Audio, Event, Infopage, Link, Picture, Stream, Video ].each do |resource_class|
      resource_class.all.each do |resource|
        # new_visibility = FindPublished.revisibility_translation(resource.visibility)
        new_visibility = 'public_indexable'
        resource.update(visibility: new_visibility)
      end
    end
  end

  def revisibility_translation(visibility)
    case visibility
    when 'public'
      'public_indexable'
    when 'unindexed'
      'public_joinable'
    when 'unlisted'
      'public_showable'
    when 'private'
      'admin_only'
    else
      'admin_only'
    end
  end



end
