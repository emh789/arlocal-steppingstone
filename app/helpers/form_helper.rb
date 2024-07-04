module FormHelper


  def form_message_picture_datetime_cascade
    'The <em>datetime cascade</em> option will order pictures based on the first available data, choosing from 1) a manually-entered date/time, 2) the date/time from image metadata, 3) the date/time from the picture file.'.html_safe
  end


end
