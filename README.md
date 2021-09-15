> This Plugin / Repo is being maintained by a community of developers.
There is no warranty given or bug fixing guarantee; especially not by
Programmfabrik GmbH. Please use the github issue tracking to report bugs
and self organize bug fixing. Feel free to directly contact the committing
developers.

# easydb-custom-data-type-gnd

This is a plugin for [easyDB 5](http://5.easydb.de/) with Custom Data Type `CustomDataTypeGND` for references to entities (only Differentiated Persons, Cooperates, Subject Headings, Place or geographic name, Works and Events) of the [Integrated Authority File (GND)](https://en.wikipedia.org/wiki/Integrated_Authority_File).

The Plugins uses <http://ws.gbv.de/suggest/gnd/> for the autocomplete-suggestions and [EntityFacts API](<http://www.dnb.de/DE/Wir/Projekte/Abgeschlossen/entityFacts.html>) from Deutsche Nationalbibliothek for additional informations about GND entities. The nightly update mechanism uses the data service of <https://lobid.org/gnd>.

## configuration

As defined in `CustomDataTypeGND.config.yml` this datatype can be configured:

### Schema options

* which entity types are offered for search
* which exact type is offered

### Mask options

* whether additional informationen is loaded if the mouse hovers a suggestion in the search result

## saved data
* conceptName
    * Preferred label of the linked record
* conceptURI
    * URI to linked record
* _fulltext
    * easydb-fulltext
* _standard
    * easydb-standard

## sources

The source code of this plugin is managed in a git repository at <https://github.com/programmfabrik/easydb-custom-data-type-gnd>. Please use [the issue tracker](https://github.com/programmfabrik/easydb-custom-data-type-gnd/issues) for bug reports and feature requests!
