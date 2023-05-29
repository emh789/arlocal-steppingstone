# A&R.Local To-Do List



## HIGHEST priority

autokeyword smells bad.

resource.visibility:
  "private" isn't really private, there is still a direct URL if a file is in storage
  - see visibility_helper
  - choose new name?
    - indexed
    - attachable
    - hidden
    - private

keyword scopes
Picture queries rely on instance methods rather than databse attributes
    effective datetime value, for example, selects from a hierarchy of three values (manual entry, exif, file)
  harder to refactor into model scopes w/o corresponding database attribute
    **Maybe bypass model scopes and just use a sorted array?**
  should this change?
Video scope
  sort_by_keyword -> can this be refactored into model scope?
**Some complex queries return a hash rather than an ActiveRecord::Association array.**
**Maybe they should be kept separate from the ActiveRecord#scope methods?**
***Conclusion***
  - keep scopes for visibility: indexable, linkable, published, etc.
  - use collection variable in `fields_for` blocks, &c.
  - assume that the query will deliver an enumerable

### finish admin renovation

  - autokeyword formatting
  - give a title to nested_picture uploads/imports
  - audio/picture not found -- clearer indicator *maybe a preceeding question mark*
  - More useful 'index' action for resources *working on it*

  *Review helper methods for currency in light of recent refactorying frenzy.*
  *related:*
    >   refactor index_joined_resource view templates
        fallout: keyword_statement_items_count methods might be unused now
        (replaced by resource_statement_items_count)

####  **TEST EVERY ACTION. LOTS OF CODE GOT RENAMED.**


video#show css
  text_data, does it need a min-width?
Video index needs headings

    + form_metadata
    + partials
      + event _form_join_by_keyword,
        + method keyword.title_with_video_count
      + event _form_join_single
      + video join_single

Not sure what these were from:
---
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



## Probably finished

wording mismatch between album.duration and audio.duration
`rounded_to` implies data manipulation **More accurate wording**
`precision` implies observation
  - album has `duration(rounded_to: :units)`
  - audio has `duration_as_text(precision: :units)`
  also look at album_audio, event_audio, etc.
  does events need event.playlist_duration or something similar? *yagni…y*

album_audio.rb &c
there are singleton methods that might not reflect the current reality.
e.g. line 10-28  `# TODO: Is this still a potentially useful method or code pattern?` **no.**

several joined_resource models have wrapper methods to prevent failure if joined is nil
is this pattern obsolete? **YES.**
