This document vault is intended for developers making a new A&R.local porfolio asset class or a new has-and-belongs-to-many relationship between portfolio asset classes.

## Definition

A *resource* is any top-level portfolio asset, including

- audio
- articles
- albums
- events
- keywords
- links
- pictures
- videos

## Extended Resource Phenotype

The power of A&R.local comes from the relations between resources and their support classes. The specificity of the relations combined with the flexibility of the user experience requires several additional support classes.

The extended phenotype of any resource may include

### Rails-included classes

- [[Controller]]
- [[has_many Join Model]]
- [[Helper]]
- [[Model]]
- [[has_many Target Model]]
- [[View]]

### A&R.local-specific support classes

- [[ResourceBuilder]]
- [[FormResourceMetadata]]
- [[QueryResources]]
- [[Sorter]]

### Rails `config/` files

- [[Routes]]

###  Rails database 

- [[Join Table]]
- [[Migration]]

