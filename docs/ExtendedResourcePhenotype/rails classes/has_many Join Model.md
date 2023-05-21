connects [[Resource]] with [[has_many Target Model]]

A *has-and-belongs-to-many* relationship will not work in most cases because ordering logic belongs on the join model.

```
counter_cache:
- belongs_to :resource, counter_cache: :target_count
- belongs_to :target, counter_cache: :resource_count
```