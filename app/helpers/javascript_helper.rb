module JavascriptHelper


  require 'json'


  def js_fragment_jp_audio_ordered(resource_audio)
    filetype = resource_audio.audio.source_file_extension_or_dummy
    { "albumOrder" => resource_audio.playlist_order,
      "title" => resource_audio.full_title,
      "duration" => resource_audio.audio.duration(rounded_to: :seconds),
      "#{filetype}" => audio_preferred_url(resource_audio.audio)
    }.to_json
  end


  def js_fragment_jp_audio_unordered(audio)
    filetype = audio.source_file_extension_or_dummy
    { "title" => audio.full_title,
      "duration" => audio.duration(rounded_to: :seconds),
      "#{filetype}" => audio_preferred_url(audio)
    }.to_json
  end


  ###########


  def js_function_album_picture_cycler(picture_filepath_string)
<<-JS_FUNCTION_ALBUM_PICTURE_CYCLER

Arlocal.current_pictureCycler = {
  _onReady: function() {
    $(document).on('click', '.arl_active_picture_viewer', function(event) { Arlocal.current_pictureCycler.cyclePictures(event, Arlocal.current_pictureCycler.pictures) });
  },
  cyclePictures: function(event, pictures) {
    var oldImageSrc = pictures.shift();
    var newImageSrc = pictures[0];
    $(event.target).attr('src', newImageSrc);
    pictures.push(oldImageSrc);
  },
  pictures: [ #{picture_filepath_string} ],
};

$(document).on('ready', Arlocal.current_pictureCycler._onReady);

JS_FUNCTION_ALBUM_PICTURE_CYCLER
  end


  ###########


  def js_function_jp_playlist_onready(playlist_json)
<<-JS_FUNCTION_JP_PLAYLIST_ONREADY

$(document).ready(function() {
  var myPlayList = new jPlayerPlaylist(
    {
      jPlayer: '#jquery_jplayer_1',
      cssSelectorAncestor: '#jp_container_1'
    },
    [
      #{playlist_json.join(',')}
    ],
    {
      playlistOptions: {},
      preload: 'none',
      solution: 'html',
      supplied: 'm4a',
      wmode: 'window'
    }
  );
});

JS_FUNCTION_JP_PLAYLIST_ONREADY
  end


  ###########


  def js_function_jp_single_onready(audio_json)
<<-JS_FUNCTION_JP_ONREADY

$(document).ready(function() {
  $('#jquery_jplayer_1').jPlayer({
    ready: function() { $(this).jPlayer('setMedia', #{audio_json} ); },
    preload: 'none',
    solution: 'html',
    supplied: 'm4a',
    wmode: 'window'
  });
});

JS_FUNCTION_JP_ONREADY
  end


  ###########


end
