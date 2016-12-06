###
 * easydb-custom-data-type-gnd - easydb 5 plugin
 * Copyright (c) 2016 Programmfabrik GmbH, Verbundzentrale des GBV (VZG)
 * MIT Licence
 * https://github.com/programmfabrik/easydb-custom-data-type-gnd
###

describe 'CustomDataTypeGND', () ->

  # create a new instance
  gndtype = new CustomDataTypeGND

  it 'should have a custom data type name', () ->
    expect(gndtype.getCustomDataTypeName()).toBe 'custom:base.custom-data-type-gnd.gnd'

  it 'should define editor fields', () ->
    fields = gndtype.__getEditorFields()
    for field in fields
      expect(field.type).toBeTruthy()

  it 'should check with getDataStatus', () ->
    cdata = {
      conceptName: " ",
      conceptURI: "\n"
    }
    expect(gndtype.getDataStatus(cdata)).toBe "empty"

    cdata = {
      conceptURI: "http://d-nb.info/gnd/1038709040",
      conceptName: "Voß, Jakob"
    }
    expect(gndtype.getDataStatus(cdata)).toBe "ok"

    cdata.conceptURI = "http://example.org/"
    expect(gndtype.getDataStatus(cdata)).toBe "invalid"

