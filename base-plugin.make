include names.md

INSTALL_FILES = \
	$(WEB)/l10n/cultures.json \
	$(WEB)/l10n/de-DE.json \
	$(WEB)/l10n/en-US.json \
	$(WEB)/l10n/es-ES.json \
	$(WEB)/l10n/it-IT.json \
	$(JS) \
	$(PLUGIN_CONFIG_FILE)

all: build

include ../base-plugins.make

build: code $(L10N)

code: $(JS)

clean: clean-base

# vim:set ft=make:
