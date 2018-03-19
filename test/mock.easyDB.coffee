###
 * easydb-custom-data-type-gnd - easydb 5 plugin
 * Copyright (c) 2016 Programmfabrik GmbH, Verbundzentrale des GBV (VZG)
 * MIT Licence
 * https://github.com/programmfabrik/easydb-custom-data-type-gnd
###

# minimal mockup of easyDB environment

class Session
    
I10N = []

$$ = (id) ->
    I10N[id]

CONFIG = []

class CustomDataType
  @register: (datatype) -> 

  getCustomSchemaSettings: () ->
    CONFIG[this.name()].schema

  getCustomMaskSettings: () ->
    CONFIG[this.name()].mask

  name: () ->
    this.constructor.name

