########################################################################
# Makefile boilerplate for easyDB5 custom datatypes.                   #
#                                                                      #
# For each custom datatype create a Makefile with content:	           #
#                                                                      #
#     DATA_TYPE_NAME=Foo                                               #
#     include easydb-custom-data-type-boilerplate.make                 #
#                                                                      #
# The DATA_TYPE_NAME is used for names of files and pathes such as     #
#                                                                      #
#     src/webfrontend/CustomDataTypeFoo.coffee.js                      #
#     build/webfrontend/custom-data-type-foo.js                        #
#     l10n/custom-data-type-foo.csv                                    #
#                                                                      #
########################################################################

include names.make

# have to use l10n2json from running docker container, so it
# is slightly complicated to launch the command
L10N2JSON = docker exec -t -i easydb-server /usr/bin/env LD_LIBRARY_PATH=/easydb-5/lib /easydb-5/bin/l10n2json

# absolute path in docker container
PATH_IN_CONTAINER=/config/plugin/$(PLUGIN_NAME)

CULTURES_CSV = l10n/cultures.csv
CULTURES_CSV_IN_CONTAINER = $(PATH_IN_CONTAINER)/l10n/cultures.csv

L10N_FILES_IN_CONTAINER = $(PATH_IN_CONTAINER)/l10n/$(PLUGIN_NAME).csv

JS_FILE = build/webfrontend/$(PLUGIN_NAME).js
TEST_FILES = $(wildcard test/*.test.coffee)

all: coffee test build-stamp-l10n

clean:
	@rm -f src/webfrontend/*.coffee.js
	@rm -f build-stamp-l10n
	@rm -rf build/
	@rm -rf test/*.spec.coffee

build-stamp-l10n: $(L10N_FILES) $(CULTURES_CSV)
	@mkdir -p build/webfrontend/l10n
	$(L10N2JSON) $(CULTURES_CSV_IN_CONTAINER) $(L10N_FILES_IN_CONTAINER) $(PATH_IN_CONTAINER)/build/webfrontend/l10n/
	@touch $@

coffee: $(JS_FILE)

$(JS_FILE): $(COFFEE_FILE).js
	mkdir -p build/webfrontend
	cat $^ > $@

test: $(patsubst %.test.coffee,%.spec.coffee,$(TEST_FILES))
	-@./node_modules/.bin/jasmine-node --coffee --verbose test

browser_test: coffee test/mock.easyDB.coffee.js

%.coffee.js: %.coffee
	@coffee -b -p --compile "$^" > "$@" && echo "$@" || ( rm -f "$@" ; false )

%.spec.coffee: test/mock.*.coffee $(COFFEE_FILE) %.test.coffee
	@cat $^ > "$@" && echo "$@"

.PHONY: clean test

# vim:set ft=make:

