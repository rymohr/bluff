## Jan 16 2012 - v0.1.0

* Migrated over to new persistence/adapter terminology

## Jan 12 2012 - v0.0.4

* Bluff calls are stricter now to give us more control in the bluff definitions. A bluff call accepts a single hash argument and default block values can no longer be defined in the block signatures.
* Added initial DSL support for **requires()**, **default()**, and **defaults()**

## Jan 11 2012 - v0.0.3

* Added architecture for multiple backend/orm support (only activerecord provided so far)
* Fixed bug with bluff extensions not locating existing classes correctly

## Jan 11 2012

* Added initial implementation with a small set of built-in data bluffs
