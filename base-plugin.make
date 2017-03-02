PLUGIN_NAME = custom-data-type-gnd
INSTALL_FILES = \
	$(WEB)/l10n/cultures.json \
	$(WEB)/l10n/de-DE.json \
	$(WEB)/l10n/en-US.json \
	$(WEB)/l10n/es-ES.json \
	$(WEB)/l10n/it-IT.json \
	$(JS) \
	CustomDataTypeGND.config.yml \
	CustomDataTypeGND-base.config.yml

L10N_FILES = l10n/$(PLUGIN_NAME).csv
COFFEE_FILES = src/webfrontend/CustomDataTypeGND.coffee

all: build

include ../base-plugins.make

build: code $(L10N)

code: $(JS)

clean: clean-base

# vim:set ft=make:
