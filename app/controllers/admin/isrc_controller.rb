class Admin::IsrcController < AdminController


  def edit
    @resources = QueryIsrc.all(@arlocal_settings, params)
  end


  def index
    @resources = QueryIsrc.all(@arlocal_settings, params)
  end


  def update
    case params['type']
    when 'Audio'
      update_audio(params)
    when 'Video'
      update_video(params)
    end
  end


  def update_audio(params)
    @audio = QueryAudio.find_admin(params[:id])
    if @audio.update_and_recount_joined_resources(params_audio_permitted)
      flash[:notice] = 'Audio was successfully updated.'
      redirect_to admin_isrc_edit_path
    else
      @resources = QueryIsrc.all(@arlocal_settings, params)
      flash[:notice] = 'Audio could not be updated.'
      render 'edit'
    end
  end


  def update_video(params)
    @video = QueryVideos.find_admin(params[:id])
    if @video.update_and_recount_joined_resources(params_video_permitted)
      flash[:notice] = 'Video was successfully updated.'
      redirect_to admin_isrc_edit_path
    else
      @resources = QueryIsrc.all(@arlocal_settings, params)
      flash[:notice] = 'Video could not be updated.'
      render 'edit'
    end
  end



  private


  def params_audio_permitted
    params.require(:audio).permit(
      :isrc_country_code,
      :isrc_designation_code,
      :isrc_registrant_code,
      :isrc_year_of_reference
    )
  end



  def params_video_permitted
    params.require(:video).permit(
      :isrc_country_code,
      :isrc_designation_code,
      :isrc_registrant_code,
      :isrc_year_of_reference
    )
  end


end
