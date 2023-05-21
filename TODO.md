# A&R.Local To-Do List


## HIGHEST priority

Album.duration(round_to_seconds) should have new option variable instead of boolean. And should be properly written.

keyword scopes
Picture queries rely on instance methods rather than dataabse attributes
    effective datetime value, for example, selects from a hierarchy of three values (manual entry, exif, file)
  harder to refactor into model scopes w/o corresponding database attribute
    **Maybe bypass model scopes and just use a sorted array?**
  should this change?
Video scope
  sort_by_keyword -> can this be refactored into model scope?
**Some complex queries return a hash rather than an ActiveRecord::Association array.**
**Maybe they should be kept separate from the ActiveRecord#scope methods?**

### finish admin renovation
  audio/picture not found -- clearer indicator
  More useful 'index' action for resources

  route/controller/etc for various _join_by_keyword

  *Review helper methods for currency in light of recent refactorying frenzy.*
  *related:*
    >   refactor index_joined_resource view templates
        fallout: keyword_statement_items_count methods might be unused now
        (replaced by resource_statement_items_count)


video#show css
  text_data, does it need a min-width?
Video index needs headings

---

- EventVideo object
  + migration
    + create join table
    + order_id, index ids,
    + integer join_count on target tables
  + Controllers basic
    + params_permitted
      + **Does this need the join table and the target?**
      + *Probably.* It looks like both are needed for all desired avenues to nest/join.
      + **YES. I remember this now.**
  + Models
    + association
    + accepts_nested_attributes
      + **Does this need the join table and the target?**
      + *Probably.* It looks like both are needed for all desired avenues to nest/join.
      + **YES. I remember this now.**
    + counters
      + models/event_video.rb
      + callbacks in event and video
    + does_have_resource methods
    + comments for attributes
  + Routes
    + leads to _Nested_ controller actions and views.
  - ArlocalSettings Sort order **no not settings, event_videos sort order**
  * Admin Edit menu
    + form metadata
      + base join but not the upload options yet. See _Nested_
        - ! partials and helpers circle back to upload/import variations here.
      - selectable query method
    + see QueryResource
    + pane button **(generated from FormMetadata)**
    + pane partials
      + base
      + see _Nested_
  * QueryResource options_for_select_admin
    + .includes
    - ties to arlocal_settings and Sorters
  + Helpers
    + resource_statement_resource_count
    + resource_reference_admin_link **(already have it.)**
    + resource_join_admin_buttons
      + leads to FormMetaData pane: resource_join_single etc. See _Nested_
  + Builders **(seems unimpacted, nothing to do.)**
  - Sorters
  + Nested
    * controller actions
      * event
        + events#video_create_from_import
        + events#video_create_from_upload
          - both lead to VideoBuilder
        + events#add_video_by_keyword
          + controller-only
          + QueryVideos find_by_keyword
      + video
        + **(Video event_join_by_keyword can use basic update method.)**

###   !!! *** WAIT *** !!!
###   Do we need all this architecture right now? Video upload/import isn't 100% implemented due to server-storage constraints and preference for embed/url.
###   using #video_join_by_keyword and #video_join_single

    + form_metadata
    + partials
      + event _form_join_by_keyword,
        + method keyword.title_with_video_count
      + event _form_join_single
      + video join_single

  - Fallout
    - models/event_audio.rb: what is self.event_hash and why?
    - FormVideoMetadata:
      - look for 'selectable: { :@pictures => lambda { |arlocal_settings| QueryPictures.options_for_select_admin_with_nil(arlocal_settings) } }'
      - no need for lambda? **probably not.**
      - do we even need it in pictures: ?  line 51
    - event datetime
      model: datetime_zone not applies anymore?
             datetime_formatted.to_s(format) doesn't accept format variable?
###     !!! `Time.zone = datetime_zone; Time.zone.local(**).to_fs(format)`

---

- give a title to nested_picture uploads/imports



## HIGH priority

- datetime to text inputs instead of selects (why? I forget.) _To avoid over/under parametizing._ Maybe just the year field? The others are fixed and cyclical.
  - why does `size: ` attribute result in larger-than-size fields? inherited from CSS maybe?


- check various `form_pictures`
  - coverpicture=true would slightly obscure the Order field
  - is a javascript thing.
  - also maybe `form_elements/join_picture_order` needs a class declaration
  - _quickly becomes a tangential UI/UX issue: reimagining the admin UI_
  - _also begs the question, keep using .is_coverpicture boolean, or use first picture by .{resource]_order?_
    - ***YES this is crucial attribute when automatically sorting by time or filename***
    - Depends on video_pictures decision. keep it simple, keep it similar.
    - probably best as a boolean

- Video: include attribute for duration? read mediainfo?

- Why does PictureKeyword have an `id_public` method? It's not even directly accessible.
  - related: are the redundant join methods such as `PictureKeyword#picture_title #picture_id #picture_slug` still needed?

- form_elements/picture_select: should it receive selectable or selectable.pictures?
  - _Check this throughout. Might be best to start with seeing what variables each form_elements requires._

- eventshelper:158 why assign js empty?

- pictures_helper picture_preferred_url
  - check if picture exists (add file_exists? method to model)
  - if not, return a dummy html_class to guarantee minimal dimensions
- form_pictures exerwhere
- picture_selector in join_single


## Medium priority

- what is this: in `app/assets/stylesheets/evo/2_public/jplayer/1_jp_audio.scss :: 2`
> // TODO: figure out why this doesn't render border-bottom or border-top
> // see .jp-type-playlist for border-bottom.
> // see .arl_albums_show_player for border-top.
>

- import/upload video via `keywords/_form_video_import`

- change the Calendar model from a module to a class
  - **Compare with video_group.** Maybe it's best as a query method?

- admin:audio#edit?id3 needs some refinement.
  - columns
  - is audio_helper the best place for the method?

+ Note where the selectable value source_type comes from the model, not via FormMetadata::Selectable
  - ***Refactoring these has low priority because there is only one @selectable item.***
    - Controllers::Admin::Audio#new_[method_to_resource]
    - Controllers::Admin::Picture#new_[method_to_resource]
  - ***Refactoring these requires deciding whether to assign SorterIndexAdmin[].options_for_select to @selectable into the controller and passing it all the way through.***
    - Helpers::AudioHelper#audio_admin_filter_select
    - Helpers::EventsHelper#event_public_filter_select
    - Helpers::PicturesHelper#picture_admin_filter_select

+ Albums#Show: section/div nesting doesn't make sense. **CSS Grid will fix this**


## Low Priority

- administrators/sign_in
  - Is it worth getting `devise::rememberable` to work correctly?

- Audio index

- about_arlocal
  - formatting for markup types, esp. for narrow width

**Continue to be mindful about including `autocomplete: false` in form elements.**


## Possibly finished

- Rails 7 upgrade
  - does importmap-rails apply? **Probably not.**
  - does jsbundling-rails apply? **Probably not.**


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

pictures -> video **DONE**
  and
    import to video
    upload to video



## Probably finished

views/shared is now views/public/shared

- admin_header_nav

- video -> keywords CSS in join table headings and data

- keyword.title_with_[rsource]_count
  - are these still being used? **Yes. in `_form_[]_join_by_keyword`**
  - anything remaining reason to keep this? no?

- Consider ActionText (sp?) for text_markup fields. No, requires webpacker &c.

clean up colors
  errors.scss
  events_index .arl_events_index_by_year
no more @includes for layout

clean up fonts (public)
clean up fonts (admin)
neighbor nav button css
isrc#review switch between index (for easy copy/paste) and edit
picture selection
views/shared vs view/form_elements
html_head_helper
  put favicon and javascript logic into respective layout templates
  is google analytics still a thing?
css image/border mixins

see:
resource.visibility
  ['indexed','unlisted','private'] (2,1,0)
  see album
  also Enum?
    https://guides.rubyonrails.org/active_record_querying.html#scopes
    https://guides.rubyonrails.org/active_record_querying.html#enums
    (although probably not.)
  source_attachment_attachment -> source_upload_attachment
  infopage.published database attribute

Is query_info_page.rb still in use? **No.**

- views/admin/shared/_index_joined
  - is this used beyond Picture? **No.**
  - app/views/admin/pictures/_show_joined_resources.haml
  - previous plan was for shared partials showing joined resources
  - is this still the plan, or should this be refactored into individual resource view partials?
    - contrast with `_admin_[resource]_stats.haml`
  - **Decision** _these partials have view logic that should be kept DRY. Consider including with other `admin#resource#show`, especially Keyword._
  - **In fact,** already being addressed in admin view overhaul.

- review routes for semantic/logical cohesion
  - obsolete routes are commented. I think all of them.
  - some are not currently in use.

***more useful 'show' action for resources***
  **"Album" is the model.**

- the 'source_attachment_attachment' syntax looks horrible. Is this really the best way to distinguish source_attachment from source_catalog?

Content storage descriptions

picture_helper has a few sus methods
**They're all called somewhere in app/*, but recent refactoring might have made some inactive calls.**
