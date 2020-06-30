class GNDUpdate

  __start_update: ({server_config, plugin_config}) ->
      # TODO: do some checks, maybe check if the library server is reachable
      ez5.respondSuccess({
        # NOTE:
        # 'state' object can contain any data the update script might need between updates.
        # the easydb server will save this and send it with any 'update' request
        state: {
            "start_update": new Date().toUTCString()
        }
      })

  __updateData: ({objects, plugin_config}) ->
    that = @
    objectsMap = {}
    GNDIds = []
    for object in objects
      if not (object.identifier and object.data)
        continue
      gndURI = object.data.conceptURI
      gndID = gndURI.split('d-nb.info/gnd/')
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
        # get updates from lobid.org
        xurl = 'https://jsontojsonp.gbv.de/?url=' + CUI.encodeURIComponentNicely('https://lobid.org/gnd/' + GNDId)

        console.error "calling " + xurl
        growingTimeout = key * 100
        setTimeout ( ->
            extendedInfo_xhr = new (CUI.XHR)(url: xurl)
            extendedInfo_xhr.start()
            .done((data, status, statusText) ->
              # validation-test on data.preferredName
              if !data.preferredName
                console.error "Record https://d-nb.info/gnd/" + gndID + " not supported in lobid.org somehow"
                console.error data
                #ez5.respondError("custom.data.type.gnd.update.error.generic", {error: "Record https://d-nb.info/gnd/" + gndID + " not supported in lobid.org yet!?"})
              else
                resultsGNDID = data['gndIdentifier']

                # then build new cdata and aggregate in objectsMap (see below)
                updatedGNDcdata = {}
                updatedGNDcdata.conceptURI = data['id']
                #updatedGNDcdata.conceptName = Date.now() + '_' + data['preferredName']
                updatedGNDcdata.conceptName = data['preferredName']

                updatedGNDcdata._standard =
                  text: updatedGNDcdata.conceptName

                updatedGNDcdata._fulltext =
                  string: ez5.GNDUtil.getFullTextFromEntityFactsJSON(data)
                  text: ez5.GNDUtil.getFullTextFromEntityFactsJSON(data)

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
    if not data
      ez5.respondError("custom.data.type.gnd.update.error.payload-missing")
      return

    for key in ["action", "server_config", "plugin_config"]
      if (!data[key])
        ez5.respondError("custom.data.type.gnd.update.error.payload-key-missing", {key: key})
        return

    if (data.action == "start_update")
      @__start_update(data)
      return

    else if (data.action == "update")
      if (!data.objects)
        ez5.respondError("custom.data.type.gnd.update.error.objects-missing")
        return

      if (!(data.objects instanceof Array))
        ez5.respondError("custom.data.type.gnd.update.error.objects-not-array")
        return

      # NOTE: state for all batches
      # this contains any arbitrary data the update script might need between batches
      # it should be sent to the server during 'start_update' and is included in each batch
      if (!data.state)
        ez5.respondError("custom.data.type.gnd.update.error.state-missing")
        return

      # NOTE: information for this batch
      # this contains information about the current batch, espacially:
      #   - offset: start offset of this batch in the list of all collected values for this custom type
      #   - total: total number of all collected custom values for this custom type
      # it is included in each batch
      if (!data.batch_info)
        ez5.respondError("custom.data.type.gnd.update.error.batch_info-missing")
        return

      # TODO: check validity of config, plugin (timeout), objects...
      @__updateData(data)
      return
    else
      ez5.respondError("custom.data.type.gnd.update.error.invalid-action", {action: data.action})

module.exports = new GNDUpdate()
