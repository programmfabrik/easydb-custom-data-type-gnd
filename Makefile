# maybe some stuff can be shared, but for now use separate build
# system for "base" and "extension" style plugin
DATA_TYPE_NAME=GND

about:
	echo $(DATA_TYPE_NAME)
	echo $(PLUGIN_NAME)
	echo $(PLUGIN_CONFIG_FILE)
	echo $(L10N_FILES)
	echo $(COFFEE_FILE)
	echo $(COFFEE_FILES)

ifeq (${BUILD_AS_BASE_PLUGIN},1)
  include base-plugin.make
else
  include easydb-custom-data-type-boilerplate.make
endif
