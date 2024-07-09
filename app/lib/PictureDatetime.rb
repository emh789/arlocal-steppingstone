module PictureDatetime

  module_function

  def set_datetime_manual_entry
    Picture.all.each do |picture|
      if picture.datetime_from_manual_entry
        Time.use_zone(picture.datetime_from_manual_entry_zone) { picture.update(datetime_from_manual_entry:  picture.datetime_from_manual_entry) }
      end
    end
  end

end
