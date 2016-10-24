# maybe some stuff can be shared, but for now use separate build
# system for "base" and "extension" style plugin
ifeq (${BUILD_AS_BASE_PLUGIN},1)
include base-plugin.make
else
DATA_TYPE_NAME=GND
include easydb-custom-data-type-boilerplate.make
endif
