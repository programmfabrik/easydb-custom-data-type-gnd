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
      gndResultName: " ",
      gndResultURI: "\n"
    }
    expect(gndtype.getDataStatus(cdata)).toBe "empty"

    cdata = {
      gndResultURI: "http://d-nb.info/gnd/1038709040",
      gndResultName: "Voß, Jakob"
    }
    expect(gndtype.getDataStatus(cdata)).toBe "ok"

    cdata.gndResultURI = "http://example.org/"
    expect(gndtype.getDataStatus(cdata)).toBe "invalid"

