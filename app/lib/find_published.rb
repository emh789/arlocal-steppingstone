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

end
