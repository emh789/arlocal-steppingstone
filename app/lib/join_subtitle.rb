module JoinSubtitle

  module_function

  def audio
    Audio.order(:id).all.each do |a|
      if a.subtitle.to_s.length > 0
        puts "#{a.id.to_s.rjust(2)}  #{a.title} (#{a.subtitle})"
        a.title = "#{a.title} (#{a.subtitle})"
        a.subtitle = ''
        a.save
      else
        puts "#{a.id.to_s.rjust(2)}  #{a.title}"
      end
    end
    nil
  end

end
