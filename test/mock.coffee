class Session

class Menu

class Pane

class DataField

class Select extends DataField

class Input extends DataField

class Output extends DataField

class FormButton extends DataField

class Icon

class CUI
    @XHR: () ->

    @parseLocation: () ->
        true

    @debug: () ->

class CustomDataType
    @register: (datatype) -> 

    getCustomSchemaSettings: () ->
        {}

$$ = () ->

console = {
    log: () ->
    debug: () ->
}
