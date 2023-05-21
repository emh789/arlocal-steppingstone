
## HABTM

connects with [[has_many Join Model]] and [[has_many Target Model]]


## Joined Pictures: important note

> This is a complex description and justification for what is ultimately a few lines of simple code.

Some resource models with joined pictures reference a [[Sorter]] named **SorterResourcePictures**.

Each resource_picture includes an attribute `resource_id` that determines their position when ordered manually. If pictures appear in the wrong order, the collection of pictures loses its meaning.

The sort order-- for example, by assigned order, or by datetime-- can be chosen as an instance attribute of the Resource: `resource_pictures_sorter_id`. Default behavior for @resource.resource_pictures returns the pictures in database order rather than the chosen order method. Since `resource_pictures_sorter_id` is an instance variable, we can't rely on the `has_many :resource_pictures` declaration to order the pictures.

Furthermore, form helpers rely on the `:resource_pictures` symbol to automagically determine the object relation and form properties; therefore, we can't easily make an additional method that gives us predictable convention-over-configuration code in the views.

We currently monkeypatch the method for `@resource.resource_pictures` to pass the collection through a sorter method.

However, duplicating this approach for `@resource.pictures` breaks the class method `Resource.reset_counters(@album)`.

Fortunately, when are not using form builders or do not require join table attributes, we are less dependent on conventions. We currently use the method `@resource.pictures_sorted` to create an ordered collection of pictures without join table attributes.

> It is possible there is a better solution.