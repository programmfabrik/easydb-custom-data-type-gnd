#
# This makefile defines additional makefile variables based on a single name:
#
# variable                  example
# DATA_TYPE_NAME            "GND"
# => PLUGIN_NAME            "custom-data-type-gnd"
# => PLUGIN_CONFIG_FILE     "CustomDataTypeGND.config.yml"
# => L10N_FILES             "l10n/custom-data-type-gnd.csv"
# => COFFEE_FILE            "src/webfrontend/CustomDataTypeGND.coffee"
# => COFFEE_FILES           "src/webfrontend/CustomDataTypeGND.coffee"

# Make does not provide a lowercase function on all platforms, so fake it
lc = $(subst A,a,$(subst B,b,$(subst C,c,$(subst D,d,$(subst E,e,$(subst F,f,$(subst G,g,$(subst H,h,$(subst I,i,$(subst J,j,$(subst K,k,$(subst L,l,$(subst M,m,$(subst N,n,$(subst O,o,$(subst P,p,$(subst Q,q,$(subst R,r,$(subst S,s,$(subst T,t,$(subst U,u,$(subst V,v,$(subst W,w,$(subst X,x,$(subst Y,y,$(subst Z,z,$1))))))))))))))))))))))))))

PLUGIN_NAME        = custom-data-type-$(call lc,$(DATA_TYPE_NAME))
PLUGIN_CONFIG_FILE = CustomDataType$(DATA_TYPE_NAME).config.yml
L10N_FILES         = l10n/$(PLUGIN_NAME).csv
COFFEE_FILE        = src/webfrontend/CustomDataType$(DATA_TYPE_NAME).coffee
COFFEE_FILES       = $(COFFEE_FILE)

# vim:set ft=make:
