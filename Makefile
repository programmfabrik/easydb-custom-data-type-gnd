PLUGIN_NAME = custom-data-type-gnd
 
L10N_FILES = easydb-library/src/commons.l10n.csv \
    l10n/$(PLUGIN_NAME).csv
L10N_GOOGLE_KEY = 1Z3UPJ6XqLBp-P8SUf-ewq4osNJ3iZWKJB83tc6Wrfn0
L10N_GOOGLE_GID = 1200588352
L10N2JSON = python easydb-library/tools/l10n2json.py

INSTALL_FILES = \
    $(WEB)/l10n/cultures.json \
    $(WEB)/l10n/de-DE.json \
    $(WEB)/l10n/en-US.json \
    $(WEB)/custom-data-type-gnd.scss \
    $(JS) \
    $(CSS) \
    CustomDataTypeGND.config.yml

COFFEE_FILES = easydb-library/src/commons.coffee \
    src/webfrontend/CustomDataTypeGND.coffee

SCSS_FILES = src/webfrontend/scss/main.scss

all: build

include easydb-library/tools/base-plugins.make

build: code css

code: $(JS) $(L10N)

clean: clean-base