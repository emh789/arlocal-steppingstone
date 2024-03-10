# A&R.Local To-Do List
## Addenda


### Unknown Origin Comments

Not sure what these were from: _(but probably from the EventVideo addenda)_:
  + form_metadata
  + partials
    + event _form_join_by_keyword,
      + method keyword.title_with_video_count
    + event _form_join_single
    + video join_single


Not sure what these were from _(but probably from the EventVideo addenda)_:
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



### EventVideo

The following outline describes an EventVideo join-relation object

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
