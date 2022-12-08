PLUGIN_NAME = custom-data-type-gnd
PLUGIN_PATH = easydb-custom-data-type-gnd

L10N_FILES = easydb-library/src/commons.l10n.csv \
    l10n/$(PLUGIN_NAME).csv

INSTALL_FILES = \
    $(WEB)/l10n/cultures.json \
    $(WEB)/l10n/de-DE.json \
    $(WEB)/l10n/en-US.json \
		build/scripts/gnd-update.js \
    $(JS) \
    $(CSS) \
    manifest.yml

COFFEE_FILES = easydb-library/src/commons.coffee \
    src/webfrontend/CustomDataTypeGND.coffee \
		src/webfrontend/GNDUtil.coffee

all: build

CSS_FILE = src/webfrontend/css/main.css

UPDATE_SCRIPT_COFFEE_FILES = \
	src/webfrontend/GNDUtil.coffee \
	src/script/GNDUpdate.coffee

UPDATE_SCRIPT_BUILD_FILE = build/scripts/gnd-update.js

${UPDATE_SCRIPT_BUILD_FILE}: $(subst .coffee,.coffee.js,${UPDATE_SCRIPT_COFFEE_FILES})
	mkdir -p $(dir $@)
	cat $^ > $@

include easydb-library/tools/base-plugins.make

build: code $(L10N) ${UPDATE_SCRIPT_BUILD_FILE} buildinfojson

code: $(JS)
			mkdir -p build/webfrontend/css
			cat $(CSS_FILE) >> build/webfrontend/custom-data-type-gnd.css

clean: clean-base

wipe: wipe-base
