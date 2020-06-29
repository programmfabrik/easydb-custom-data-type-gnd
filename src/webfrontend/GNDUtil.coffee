# examples:
# VolksWagenStiftung - https://jsontojsonp.gbv.de/?url=https:%2F%2Flobid.org%2Fgnd%2F5004690-1
# Albrecht Dürer - https://jsontojsonp.gbv.de/?url=https:%2F%2Flobid.org%2Fgnd%2F11852786X
# Entdeckung der Zauberflöte . http://lobid.org/gnd/7599114-7.json
# Edvard Grieg - https://jsontojsonp.gbv.de/?url=https:%2F%2Flobid.org%2Fgnd%2F118697641

# some fields are missing, thats on purpose. This is a curated selection, because not all fields make sense

# "# ++" --> doublechecked
# "# + checked" --> should theoretically work, but needs more explicit testing

class ez5.GNDUtil
  @getFullTextFromEntityFactsJSON: (efJSON) ->
    _fulltext = ''

    # ++
    _fulltext += efJSON['id'] + ' '

    # ++
    _fulltext = efJSON['gndIdentifier'] + ' '

    # ++
    if efJSON?.oldAuthorityNumber
      for entry in efJSON.oldAuthorityNumber
        _fulltext += entry + ' '

    # ++
    if efJSON?.gndSubjectCategory
      for entry in efJSON.gndSubjectCategory
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    _fulltext += efJSON['preferredName'] + ' '

    # ++
    if efJSON?.variantName
      for entry in efJSON.variantName
        _fulltext += entry + ' '

    # ++
    if efJSON?.biographicalOrHistoricalInformation
      for entry in efJSON.biographicalOrHistoricalInformation
        _fulltext += entry + ' '

    # ++
    if efJSON?.dateOfEstablishment
      for entry in efJSON.dateOfEstablishment
        _fulltext += entry + ' '

    # ++
    if efJSON?.dateOfPublication
      for entry in efJSON.dateOfPublication
        _fulltext += entry + ' '

    # ++
    if efJSON?.dateOfBirth
      _fulltext += efJSON.dateOfBirth + ' '

    if efJSON?.dateOfProduction
      _fulltext += efJSON.dateOfProduction + ' '

    # ++
    if efJSON?.dateOfDeath
      _fulltext += efJSON.dateOfDeath + ' '

    # + checked
    if efJSON?.dateOfTermination
      _fulltext += efJSON.dateOfTermination + ' '

    # ++
    if efJSON?.author
      for entry in efJSON.author
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.firstAuthor
      for entry in efJSON.firstAuthor
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.gender
      for entry in efJSON.gender
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.placeOfBirth
      for entry in efJSON.placeOfBirth
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.placeOfDeath
      for entry in efJSON.placeOfDeath
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.placeOfBusiness
      for entry in efJSON.placeOfBusiness
        if entry.label
          _fulltext += entry.label + ' '

    if efJSON?.associatedPlace
      for entry in efJSON.associatedPlace
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.topic
      for entry in efJSON.topic
        if entry.label
          _fulltext += entry.label + ' '

    if efJSON?.predecessor
      for entry in efJSON.predecessor
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.precedingCorporateBody
      for entry in efJSON.precedingCorporateBody
        if entry.label
          _fulltext += entry.label + ' '

    if efJSON?.isA
      for entry in efJSON.isA
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.composer
      for entry in efJSON.composer
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.relatedWork
      for entry in efJSON.relatedWork
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.relatedPerson
      for entry in efJSON.relatedPerson
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.precedingPlaceOrGeographicName
      for entry in efJSON.precedingPlaceOrGeographicName
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.hierarchicalSuperiorOfTheCorporateBody
      for entry in efJSON.hierarchicalSuperiorOfTheCorporateBody
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.broaderTermInstantial
      for entry in efJSON.broaderTermInstantial
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.broaderTermGeneral
      for entry in efJSON.broaderTermGeneral
        if entry.label
          _fulltext += entry.label + ' '

    # ++
    if efJSON?.professionOrOccupation
      for entry in efJSON.professionOrOccupation
        if entry.label
          _fulltext += entry.label + ' '

    if efJSON?.architect
      for entry in efJSON.architect
        if entry.label
          _fulltext += entry.label + ' '

    if efJSON?.opusNumericDesignationOfMusicalWork
      for entry in efJSON.opusNumericDesignationOfMusicalWork
          _fulltext += entry + ' '

    # ++
    if efJSON?.definition
      for entry in efJSON.definition
          _fulltext += entry + ' '

    return _fulltext
