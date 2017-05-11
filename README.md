# easydb-custom-data-type-gnd

This is a plugin for [easyDB 5](http://5.easydb.de/) with Custom Data Type `CustomDataTypeGND` for references to entities (only Differentiated Persons, Cooperates, Subject Headings, Place or geographic name) of the [Integrated Authority File (GND)](https://en.wikipedia.org/wiki/Integrated_Authority_File).

The Plugins uses <http://ws.gbv.de/suggest/gnd/> for the autocomplete-suggestions and [EntityFacts API](<http://www.dnb.de/DE/Wir/Projekte/Abgeschlossen/entityFacts.html>) from Deutsche Nationalbibliothek for additional informations about GND entities.

## configuration

As defined in `CustomDataTypeGND.config.yml` this datatype can be configured:

### Schema options

* which entity types are offered for search
* which exact type is offered

### Mask options

* whether additional informationen is loaded if the mouse hovers a suggestion in the search result

## sources

The source code of this plugin is managed in a git repository at <https://github.com/programmfabrik/easydb-custom-data-type-gnd>. Please use [the issue tracker](https://github.com/programmfabrik/easydb-custom-data-type-gnd/issues) for bug reports and feature requests!

