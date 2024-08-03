# A&R.Local To-Do List


## Possibly finished

- _Grid layout fixes many of the other admin:welcome content pages._

Possibly some bugs remaining here.

- review video picture import-- does it still fail? Check upload too.
- Fixed, BUT:
  - Video :has_one picture as a thumbnail
  -   by comparison,
  - Event :has_many pictures as a collection
  -   therefore
  - The supplementary methods for importing will look different.
  - Should this remain, or should Video-Picture be a :has_many relationship?
  - **Probably should be a :has_many relationship for consistency.**
  - ***Is that certain? Video only needs a thumbnail.***
  - but it might be useful to have a collection of stills, just as an event can have several pictures.
  - db table already video_pictures, just add video_order.


## Probably finished

  audio: why are durations `super.to_i`? *historical reasons. refactor to where integers are necessary, leave attribute method alone.*
  wording mismatch between album.duration and audio.duration
  `rounded_to` implies data manipulation **More accurate wording**
  `precision` implies observation
    - album has `duration(rounded_to: :units)`
    - audio has `duration_as_text(precision: :units)`
    also look at album_audio, event_audio, etc.
    does events need event.playlist_duration or something similar? *yagni…y*

Where to Sort vs Where to Query
  - previously depended more on a variety of singleton scopes chained in the controller
  - current scopes are for public/private visibility
  - Most sort methods are held in the Query; exceptions are album_ and event_pictures
    - _`Album` is the model for refactoring._

- question remains of how to handle `year` parameter
  - multiparameter fields (album.date_released, date_select) cause difficulty validating
  - multiple attributes (audio.duration) lack elegance & require multiple columns, but fit better with rails conventions
  - ***wowee zowee date_field helper solves this!***
    - see if it fixes _datetime_zone.haml
    - *Yes, if I can finally understand how to make the time zones work!!*
    - datetime to text inputs instead of selects (why? I forget.) _To avoid over/under parametizing._ Maybe just the year field? The others are fixed and cyclical.

- `admin/welcome/markup_types` needs dynamic layout. grid fixes this. _no it doesn't_
  - **Might need a rewrite with a `param` and `<select>`**
  - panes: summary, simpleformat, markdown, none
  - about_arlocal
    - formatting for markup types, esp. for narrow width

- picture titles show markup in joined_resources
- picture_options_for_select picture.title_for_select
  - still shows markup
  - not sure why/how. re-saving each picture fixes it

- `views/admin/shared/_index_joined_pictures` and `…/_show_join_pictures`
  - currently using `picture.title_without_markup`
  - formatting is inconsistent with `parser_div(picture.title_props)`
  - *title_props would be preferable. fix the formatting.*
  - *layout glitch comes from nested <p> in parser_result*

- visibility touchup
  - public      publicly_linkable published publicly_indexable
  - unindexed   publicly_linkable published
  - unlisted    publicly_linkable
  - private

- picture_keyword checkboxes are still oldschool css

- Builder methods
  - some specify empty string for _markup_text; others are nil. What difference?
    - difference looks like formality and thoroughness, nothing functional
    - keep '' with arlocal_settings because all other options need a starting value
    - but it looks unnecessary on other resources with fewer required defaults

- video#edit?keyword uses old checkbox

- `Audio.title` should avoid calling *super*
  - find why and make a semantic sugar method

  - Event datetime could use datetime_field form helper
    - however, the app uses the time entered in the zone local to the event
    - whereas rails assumes Time is local to the app and converts it to UTC
    - I don't yet see how to preserve the event timezone independently of UTC and local app timezone conversions
    - will require a database migration to merge separate columns into a single datetime column
  - Same issue with picture datetime_manual_entry
  - maybe use around_action filter in controller
  - see https://api.rubyonrails.org/classes/Time.html#method-c-use_zone
  ```
  class ApplicationController < ActionController::Base
    around_action :set_time_zone

    private
      def set_time_zone
        Time.use_zone(current_user.timezone) { yield }
      end
  end
  ```
  - and also for Models/views
  ```
  datetime_utc.in_time_zone(datetime_zone)
  datetime_field
  datetime_local_field
  pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}" required
  ```
  - So many contradictions here. Best option seems to be datetime_field despite not having yyyy-mm-dd format

- Picture datetime can be simplified. See `@event.datetime`
