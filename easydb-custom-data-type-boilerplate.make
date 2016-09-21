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

# have to use l10n2json from running docker container, so it
# is slightly complicated to launch the command
L10N2JSON = docker exec -t -i easydb-server /usr/bin/env LD_LIBRARY_PATH=/easydb-5/lib /easydb-5/bin/l10n2json

# Make does not provide a lowercase function on all platforms, so fake it
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

DATA_TYPE_FILENAME=custom-data-type-$(call lc,$(DATA_TYPE_NAME))

# absolute path in docker container
PATH_IN_CONTAINER=/config/plugin/$(DATA_TYPE_FILENAME)

CULTURES_CSV = l10n/cultures.csv
CULTURES_CSV_IN_CONTAINER = $(PATH_IN_CONTAINER)/l10n/cultures.csv

L10N_FILES = l10n/$(DATA_TYPE_FILENAME).csv
L10N_FILES_IN_CONTAINER = $(PATH_IN_CONTAINER)/l10n/$(DATA_TYPE_FILENAME).csv

JS_FILE = build/webfrontend/$(DATA_TYPE_FILENAME).js

all: ${JS_FILE} build-stamp-l10n

clean:
	rm -f src/webfrontend/*.coffee.js
	rm -f build-stamp-l10n
	rm -rf build/
	rm -rf test/*.coffee.js

build-stamp-l10n: $(L10N_FILES) $(CULTURES_CSV)
	mkdir -p build/webfrontend/l10n
	$(L10N2JSON) $(CULTURES_CSV_IN_CONTAINER) $(L10N_FILES_IN_CONTAINER) $(PATH_IN_CONTAINER)/build/webfrontend/l10n/
	touch $@

${JS_FILE}: src/webfrontend/CustomDataType$(DATA_TYPE_NAME).coffee.js
	mkdir -p build/webfrontend
	cat $^ > $@

test: ${JS_FILE} test/mock.coffee.js test/smoke.coffee.js
	cat test/mock.coffee.js ${JS_FILE} test/smoke.coffee.js > test/tmp.coffee.js
	node test/tmp.coffee.js

%.coffee.js: %.coffee
	coffee -b -p --compile "$^" > "$@" || ( rm -f "$@" ; false )

.PHONY: clean
