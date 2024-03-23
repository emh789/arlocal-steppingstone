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
      update_audio
    when 'Video'
      update_video
    end
  end


  def update_audio
    @audio = QueryAudio.find_admin(params[:audio][:id])
    if @audio.update_and_recount_joined_resources(params_audio_permitted)
      flash[:notice] = 'Audio was successfully updated.'
      redirect_to admin_isrc_review_path
    else
      @resources = QueryIsrc.all(@arlocal_settings, params)
      flash[:notice] = 'Audio could not be updated.'
      render 'edit'
    end
  end


  def update_video
    @video = QueryVideos.find_admin(params[:video][:id])
    if @video.update_and_recount_joined_resources(params_video_permitted)
      flash[:notice] = 'Video was successfully updated.'
      redirect_to admin_isrc_review_path
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
      :id,
      :isrc_country_code,
      :isrc_designation_code,
      :isrc_registrant_code,
      :isrc_year_of_reference
    )
  end


end
