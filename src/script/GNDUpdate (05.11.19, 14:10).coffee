class GNDUpdate

  __startup: ({server_config, plugin_config}) ->
    ez5.respondSuccess({payload: "OK"})

  __updateData: ({objects, plugin_config}) ->
    that = @
    objectsMap = {}
    GNDIds = []
    for object in objects
      if not (object.identifier and object.data)
        continue
      gndURI = object.data.conceptURI
      gndID = gndURI.split('http://d-nb.info/gnd/')
      gndID = gndID[1]
      if CUI.util.isEmpty(gndID)
        continue
      if not objectsMap[gndID]
        objectsMap[gndID] = [] # It is possible to  have more than one object with the same ID in different objects.
      objectsMap[gndID].push(object)
      GNDIds.push(gndID)

    if GNDIds.length == 0
      return ez5.respondSuccess({payload: []})

    timeout = plugin_config.update?.timeout or 0
    timeout *= 1000 # The configuration is in seconds, so it is multiplied by 1000 to get milliseconds.

    # unique gnd-ids
    GNDIds = GNDIds.filter((x, i, a) => a.indexOf(x) == i)

    objectsToUpdate = []

    xhrPromises = []
    for GNDId, key in GNDIds
      deferred = new CUI.Deferred()
      xhrPromises.push deferred
    console.error "GNDIds ", GNDIds
    for GNDId, key in GNDIds
      do(key, GNDId) ->
        console.error key
        xurl = 'https://jsontojsonp.gbv.de/?url=' + CUI.encodeURIComponentNicely('http://hub.culturegraph.org/entityfacts/' + GNDId)
        console.error "calling " + xurl
        growingTimeout = key * 100
        setTimeout ( ->
            extendedInfo_xhr = new (CUI.XHR)(url: xurl)
            extendedInfo_xhr.start()
            .done((data, status, statusText) ->
              # validation-test on data.preferredName
              if !data.preferredName
                console.error "Record http://d-nb.info/gnd/" + gndID + " not supported in EntityFacts yet"
                #ez5.respondError("custom.data.type.gnd.update.error.generic", {error: "Record http://d-nb.info/gnd/" + gndID + " not supported in EntityFacts yet"})
              else
                resultsGNDID = data['@id']
                resultsGNDID = resultsGNDID.replace('http://d-nb.info/gnd/', '')

                # then build new cdata and aggregate in objectsMap (see below)
                updatedGNDcdata = {}
                updatedGNDcdata.conceptURI = data['@id']
                #updatedGNDcdata.conceptName = Date.now() + '_' + data['preferredName']
                updatedGNDcdata.conceptName = data['preferredName']

                updatedGNDcdata._standard =
                  text: updatedGNDcdata.conceptName

                updatedGNDcdata._fulltext =
                  string: ez5.GNDUtil.getFullTextFromEntityFactsJSON(data) + '_123'

                if !objectsMap[resultsGNDID]
                  console.error "GND nicht in objectsMap: " + resultsGNDID
                  console.error "da hat sich die ID von " + GNDId + " zu " + resultsGNDID + " geändert"
                for objectsMapEntry in objectsMap[GNDId]
                  if not that.__hasChanges(objectsMapEntry.data, updatedGNDcdata)
                    continue
                  objectsMapEntry.data = updatedGNDcdata # Update the object that has changes.
                  objectsToUpdate.push(objectsMapEntry)
            )
            .fail ((data, status, statusText) ->
              ez5.respondError("custom.data.type.gnd.update.error.generic", {searchQuery: searchQuery, error: e + "Error connecting to entityfacts"})
            )
            .always =>
              xhrPromises[key].resolve()
              xhrPromises[key].promise()
        ), growingTimeout

    CUI.whenAll(xhrPromises).done( =>
      ez5.respondSuccess({payload: objectsToUpdate})
    )

  __hasChanges: (objectOne, objectTwo) ->
    for key in ["conceptName", "conceptURI", "_standard", "_fulltext"]
      if not CUI.util.isEqual(objectOne[key], objectTwo[key])
        return true
    return false

  main: (data) ->
    console.error data
    console.error "main 1"

    if not data
      ez5.respondError("custom.data.type.gnd.update.error.payload-missing")
      return

    for key in ["action", "server_config", "plugin_config"]
      if (!data[key])
        ez5.respondError("custom.data.type.gnd.update.error.payload-key-missing", {key: key})
        return

    if (data.action == "startup")
      console.error "main 2 --> startup"
      @__startup(data)
      return

    else if (data.action == "update")
      console.error "main 3 --> update"
      if (!data.objects)
        ez5.respondError("custom.data.type.gnd.update.error.objects-missing")
        return

      if (!(data.objects instanceof Array))
        ez5.respondError("custom.data.type.gnd.update.error.objects-not-array")
        return

      # TODO: check validity of config, plugin (timeout), objects...
      @__updateData(data)
      return
    else
      ez5.respondError("custom.data.type.gnd.update.error.invalid-action", {action: data.action})

module.exports = new GNDUpdate()
