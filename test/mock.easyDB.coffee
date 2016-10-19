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

