# maybe some stuff can be shared, but for now use separate build
# system for "base" and "extension" style plugin
L10N_GOOGLE_KEY = 1Z3UPJ6XqLBp-P8SUf-ewq4osNJ3iZWKJB83tc6Wrfn0
L10N_GOOGLE_GID = 196999435

ifeq (${BUILD_AS_BASE_PLUGIN},1)
include base-plugin.make
else
DATA_TYPE_NAME=GND
include easydb-custom-data-type-boilerplate.make
endif
