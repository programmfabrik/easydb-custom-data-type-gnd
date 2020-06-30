class CustomDataTypeGND extends CustomDataTypeWithCommons

  #######################################################################
  # return name of plugin
  getCustomDataTypeName: ->
    "custom:base.custom-data-type-gnd.gnd"


  #######################################################################
  # return name (l10n) of plugin
  getCustomDataTypeNameLocalized: ->
    $$("custom.data.type.gnd.name")


  #######################################################################
  # if type is DifferentiatedPerson, PlaceOrGeographicName or CorporateBody, get short info about entry from entityfacts
  __getAdditionalTooltipInfo: (uri, tooltip, extendedInfo_xhr) ->
    # extract gndID from uri
    gndID = uri
    gndIDTest = gndID.split "/"
    if gndIDTest.length == 1
      gndID = gndID.split "%2F"
    else
      gndID = gndIDTest
    gndID = gndID.pop()
    # download infos
    if extendedInfo_xhr.xhr != undefined
      # abort eventually running request
      extendedInfo_xhr.abort()
    # start new request
    xurl = location.protocol + '//jsontojsonp.gbv.de/?url=http://hub.culturegraph.org/entityfacts/' + gndID
    extendedInfo_xhr = new (CUI.XHR)(url: xurl)
    extendedInfo_xhr.start()
    .done((data, status, statusText) ->
        if !data.preferredName
          tooltip.hide()
        else
          htmlContent = ''
          htmlContent += '<table style="border-spacing: 10px; border-collapse: separate;">'
          htmlContent += '<tr><td colspan="2"><h4>Informationen über den Eintrag</h4></td></tr>'
          ##########################
          # DifferentiatedPerson, PlaceOrGeographicName and CorporateBody

          # Vollständiger Name (DifferentiatedPerson + CorporateBody)
          htmlContent += "<tr><td>Name:</td><td>" + data.preferredName + "</td></tr>"
          # Abbildung (DifferentiatedPerson + CorporateBody)
          depiction = data.depiction
          if depiction
            if depiction.thumbnail
              htmlContent += '<tr><td>Abbildung:</td><td><img src="' + depiction.thumbnail['@id'] + '" style="border: 0; max.width:120px; max-height:150px;" /></td></tr>'
          # Lebensdaten (DifferentiatedPerson)
          dateOfBirth = data.dateOfBirth
          dateOfDeath = data.dateOfDeath
          if dateOfBirth or dateOfDeath
            htmlContent += "<tr><td>Lebensdaten:</td><td>"
            if dateOfBirth and dateOfDeath
              htmlContent += dateOfBirth + " bis " + dateOfDeath
            else if dateOfBirth and !dateOfDeath
              htmlContent += dateOfBirth + " bis unbekannt"
            else if !dateOfBirth and dateOfDeath
              htmlContent += "unbekannt bis " + dateOfDeath
            htmlContent += "</td></tr>"
          # Date of Establishment (CorporateBody)
          dateOfEstablishment = data.dateOfEstablishment
          if dateOfEstablishment
            htmlContent += "<tr><td>Gründung:</td><td>" + dateOfEstablishment[0] + "</td></tr>"
          # Place of Business (CorporateBody)
          placeOfBusiness = data.placeOfBusiness
          places = []
          if placeOfBusiness
            if placeOfBusiness.length > 0
              for place in placeOfBusiness
                places.push(place.preferredName)
              htmlContent += "<tr><td>Niederlassung(en):</td><td>" + places.join("<br />") + "</td></tr>"
          # Übergeordnete Körperschaft (CorporateBody)
          hierarchicallySuperiorOrganisation = data.hierarchicallySuperiorOrganisation
          organisations = []
          if hierarchicallySuperiorOrganisation
            if hierarchicallySuperiorOrganisation.length > 0
              for organisation in hierarchicallySuperiorOrganisation
                organisations.push(organisation.preferredName)
              htmlContent += "<tr><td>Übergeordnete Körperschaft(en):</td><td>" + organisations.join("<br />") + "</td></tr>"
          # Geburtsort (DifferentiatedPerson)
          placeOfBirth = data.placeOfBirth
          if placeOfBirth
            htmlContent += "<tr><td>Geburtsort:</td><td>" + placeOfBirth[0].preferredName + "</td></tr>"
          # Sterbeort (DifferentiatedPerson)
          placeOfDeath = data.placeOfDeath
          if placeOfDeath
            htmlContent += "<tr><td>Sterbeort:</td><td>" + placeOfDeath[0].preferredName + "</td></tr>"
          # Berufe (DifferentiatedPerson)
          professionOrOccupation = data.professionOrOccupation
          professions = []
          if professionOrOccupation
            if professionOrOccupation.length > 0
              for profession in professionOrOccupation
                professions.push(profession.preferredName)
              htmlContent += "<tr><td>Beruf(e):</td><td>" + professions.join("<br />") + "</td></tr>"
          # Biographie (DifferentiatedPerson)
          biographicalOrHistoricalInformation = data.biographicalOrHistoricalInformation
          if biographicalOrHistoricalInformation
            htmlContent += "<tr><td>Biographie:</td><td>" + biographicalOrHistoricalInformation + "</td></tr>"
          # Thema (CorporateBody)
          topic = data.topic
          topics = []
          if topic
            if topic.length > 0
              for t in topic
                topics.push(t.preferredName)
              htmlContent += "<tr><td>Themen:</td><td>" + topics.join("<br />") + "</td></tr>"

          # Synonyme (DifferentiatedPerson + CorporateBody)
          variantName = data.variantName
          if variantName
            if variantName.length > 0
              variantNames = variantName.join("<br />")
              htmlContent += "<tr><td>Synonyme:</td><td>" + variantNames + "</td></tr>"

          htmlContent += "</table>"
          tooltip.DOM.innerHTML = htmlContent
          tooltip.autoSize()
    )
    .fail (data, status, statusText) ->
        tooltip.hide()

    return


  #######################################################################
  # handle suggestions-menu
  __updateSuggestionsMenu: (cdata, cdata_form, searchstring, input, suggest_Menu, searchsuggest_xhr, layout, opts) ->
    that = @

    delayMillisseconds = 200

    setTimeout ( ->
      gnd_searchterm = searchstring

      gnd_searchtype = false
      gnd_countSuggestions = 50
      if (cdata_form)
        gnd_searchtype = cdata_form.getFieldsByName("gndSelectType")[0].getValue()
        gnd_countSuggestions = cdata_form.getFieldsByName("countOfSuggestions")[0].getValue()

      # if "search-all-types", search all allowed types
      if gnd_searchtype == 'all_supported_types' || ! gnd_searchtype
        gnd_searchtype = []
        if that.getCustomSchemaSettings().add_differentiatedpersons?.value
          gnd_searchtype.push 'DifferentiatedPerson'
        if that.getCustomSchemaSettings().add_coorporates?.value
          gnd_searchtype.push 'CorporateBody'
        if that.getCustomSchemaSettings().add_geographicplaces?.value
          gnd_searchtype.push 'PlaceOrGeographicName'
        if that.getCustomSchemaSettings().add_subjects?.value
          gnd_searchtype.push 'SubjectHeading'
        if that.getCustomSchemaSettings().add_works?.value
          gnd_searchtype.push 'Work'
        gnd_searchtype = gnd_searchtype.join(',')

      # if only a "subclass" is active
      subclass = that.getCustomSchemaSettings().exact_types?.value
      subclassQuery = ''

      if subclass != undefined
        if subclass != 'ALLE'
          subclassQuery = '&exact_type=' + subclass

      if gnd_searchterm.length == 0
          return

      # run autocomplete-search via xhr
      if searchsuggest_xhr.xhr != undefined
          # abort eventually running request
          searchsuggest_xhr.xhr.abort()

      # start new request
      searchsuggest_xhr.xhr = new (CUI.XHR)(url: location.protocol + '//ws.gbv.de/suggest/gnd/?searchterm=' + gnd_searchterm + '&type=' + gnd_searchtype + subclassQuery + '&count=' + gnd_countSuggestions)
      searchsuggest_xhr.xhr.start().done((data, status, statusText) ->

          # init xhr for tooltipcontent
          extendedInfo_xhr = { "xhr" : undefined }
          # create new menu with suggestions
          menu_items = []
          for suggestion, key in data[1]
            do(key) ->
              # the actual Featureclass...
              aktType = data[2][key]
              lastType = ''
              if key > 0
                lastType = data[2][key-1]
              if aktType != lastType
                item =
                  divider: true
                menu_items.push item
                item =
                  label: aktType
                menu_items.push item
                item =
                  divider: true
                menu_items.push item
              item =
                text: suggestion
                value: data[3][key]
                tooltip:
                  markdown: true
                  placement: "e"
                  content: (tooltip) ->
                    # if enabled in mask-config
                    if that.getCustomMaskSettings().show_infopopup?.value
                      # if type is ready for infopopup
                      aktType = aktType.split(' / ')
                      aktType = aktType[0]
                      if aktType == "DifferentiatedPerson" or aktType == "CorporateBody" or aktType == "PlaceOrGeographicName"
                        that.__getAdditionalTooltipInfo(data[3][key], tooltip, extendedInfo_xhr)
                        new CUI.Label(icon: "spinner", text: "lade Informationen")
              menu_items.push item

          # set new items to menu
          itemList =
            keyboardControl: true
            onClick: (ev2, btn) ->
              # lock in save data
              cdata.conceptURI = btn.getOpt("value")
              GNDURIParts = cdata.conceptURI.split '/'
              GNDId = GNDURIParts.pop()
              cdata.conceptName = btn.getText()

              # get more informations from lobid.org
              xurl = 'https://jsontojsonp.gbv.de/?url=' + CUI.encodeURIComponentNicely('https://lobid.org/gnd/' + GNDId)
              extendedInfo_xhr = new (CUI.XHR)(url: xurl)
              extendedInfo_xhr.start()
              .done((data, status, statusText) ->
                resultsGNDID = data['gndIdentifier']

                cdata.conceptURI = data['id']

                cdata._standard =
                  text: cdata.conceptName

                cdata._fulltext =
                  string: ez5.GNDUtil.getFullTextFromEntityFactsJSON(data)
                  text: ez5.GNDUtil.getFullTextFromEntityFactsJSON(data)
              )


              .always(() ->
                # update the layout in form
                that.__updateResult(cdata, layout, opts)
                # hide suggest-menu
                suggest_Menu.hide()
                # close popover
                if that.popover
                  that.popover.hide()
                @
              )

            items: menu_items

          # if no hits set "empty" message to menu
          if itemList.items.length == 0
            itemList =
              items: [
                text: "kein Treffer"
                value: undefined
              ]

          suggest_Menu.setItemList(itemList)

          suggest_Menu.show()
      )
    ), delayMillisseconds


  #######################################################################
  # create form
  __getEditorFields: (cdata) ->
    # read searchtypes from datamodell-options
    dropDownSearchOptions = []
    # offer DifferentiatedPerson
    if @getCustomSchemaSettings().add_differentiatedpersons?.value
        option = (
            value: 'DifferentiatedPerson'
            text: $$('custom.data.type.gnd.config.parameter.schema.add_differentiatedpersons.value.checkbox')
          )
        dropDownSearchOptions.push option
    # offer CorporateBody?
    if @getCustomSchemaSettings().add_coorporates?.value
        option = (
            value: 'CorporateBody'
            text: $$('custom.data.type.gnd.config.parameter.schema.add_coorporates.value.checkbox')
          )
        dropDownSearchOptions.push option
    # offer PlaceOrGeographicName?
    if @getCustomSchemaSettings().add_geographicplaces?.value
        option = (
            value: 'PlaceOrGeographicName'
            text: $$('custom.data.type.gnd.config.parameter.schema.add_geographicplaces.value.checkbox')
          )
        dropDownSearchOptions.push option
    # offer add_subjects?
    if @getCustomSchemaSettings().add_subjects?.value
        option = (
            value: 'SubjectHeading'
            text: $$('custom.data.type.gnd.config.parameter.schema.add_subjects.value.checkbox')
          )
        dropDownSearchOptions.push option
    # offer add_works?
    if @getCustomSchemaSettings().add_works?.value
        option = (
            value: 'Work'
            text: $$('custom.data.type.gnd.config.parameter.schema.add_works.value.checkbox')
          )
        dropDownSearchOptions.push option
    # add "Alle"-Option? If count of options > 1!
    if dropDownSearchOptions.length > 1
        option = (
            value: 'all_supported_types'
            text: $$('custom.data.type.gnd.config.option.schema.exact_types.value.all')
          )
        dropDownSearchOptions.unshift option
    # if empty options -> offer all
    if dropDownSearchOptions.length == 0
        dropDownSearchOptions = [
          (
            value: 'DifferentiatedPerson'
            text: 'Individualisierte Personen'
          )
          (
            value: 'CorporateBody'
            text: 'Körperschaften'
          )
          (
            value: 'PlaceOrGeographicName'
            text: 'Orte und Geographische Namen'
          )
          (
            value: 'SubjectHeading'
            text: 'Schlagwörter'
          )
          (
            value: 'Work'
            text: 'Werke'
          )
        ]
    [{
      type: CUI.Select
      undo_and_changed_support: false
      form:
          label: $$('custom.data.type.gnd.modal.form.text.type')
      options: dropDownSearchOptions
      name: 'gndSelectType'
      class: 'commonPlugin_Select'
    }
    {
      type: CUI.Select
      undo_and_changed_support: false
      class: 'commonPlugin_Select'
      form:
          label: $$('custom.data.type.gnd.modal.form.text.count')
      options: [
        (
            value: 10
            text: '10 ' + $$('custom.data.type.gnd.modal.form.text.count_short')
        )
        (
            value: 20
            text: '20 ' + $$('custom.data.type.gnd.modal.form.text.count_short')
        )
        (
            value: 50
            text: '50 ' + $$('custom.data.type.gnd.modal.form.text.count_short')
        )
        (
            value: 100
            text: '100 ' + $$('custom.data.type.gnd.modal.form.text.count_short')
        )
        (
            value: 250
            text: '250 ' + $$('custom.data.type.gnd.modal.form.text.count_short')
        )
      ]
      name: 'countOfSuggestions'
    }
    {
      type: CUI.Input
      undo_and_changed_support: false
      form:
          label: $$("custom.data.type.gnd.modal.form.text.searchbar")
      placeholder: $$("custom.data.type.gnd.modal.form.text.searchbar.placeholder")
      name: "searchbarInput"
      class: 'commonPlugin_Input'
    }
    {
      form:
        label: $$('custom.data.type.gnd.modal.form.text.result.label')
      type: CUI.Output
      name: "conceptName"
      data: {conceptName: cdata.conceptName}
    }
    {
      form:
        label: $$('custom.data.type.gnd.modal.form.text.uri.label')
      type: CUI.FormButton
      name: "conceptURI"
      icon: new CUI.Icon(class: "fa-lightbulb-o")
      text: cdata.conceptURI
      onClick: (evt,button) =>
        window.open cdata.conceptURI, "_blank"
      onRender : (_this) =>
        if cdata.conceptURI == ''
          _this.hide()
    }
    ]


  #######################################################################
  # renders the "result" in original form (outside popover)
  __renderButtonByData: (cdata) ->

    # when status is empty or invalid --> message

    switch @getDataStatus(cdata)
      when "empty"
        return new CUI.EmptyLabel(text: $$("custom.data.type.gnd.edit.no_gnd")).DOM
      when "invalid"
        return new CUI.EmptyLabel(text: $$("custom.data.type.gnd.edit.no_valid_gnd")).DOM

    # if status is ok
    conceptURI = CUI.parseLocation(cdata.conceptURI).url

    # if conceptURI .... ... patch abwarten

    tt_text = $$("custom.data.type.gnd.url.tooltip", name: cdata.conceptName)

    # output Button with Name of picked dante-Entry and URI
    encodedURI = encodeURIComponent(cdata.conceptURI)
    new CUI.HorizontalLayout
      maximize: true
      left:
        content:
          new CUI.Label
            centered: false
            text: cdata.conceptName
      center:
        content:
          # output Button with Name of picked Entry and Url to the Source
          new CUI.ButtonHref
            appearance: "link"
            href: cdata.conceptURI
            target: "_blank"
            tooltip:
              markdown: true
              text: tt_text
      right: null
    .DOM


  #######################################################################
  # zeige die gewählten Optionen im Datenmodell unter dem Button an
  getCustomDataOptionsInDatamodelInfo: (custom_settings) ->
    tags = []

    if custom_settings.add_differentiatedpersons?.value
      tags.push "✓ Personen"
    else
      tags.push "✘ Personen"

    if custom_settings.add_coorporates?.value
      tags.push "✓ Körperschaften"
    else
      tags.push "✘ Körperschaften"

    if custom_settings.add_geographicplaces?.value
      tags.push "✓ Orte"
    else
      tags.push "✘ Orte"

    if custom_settings.add_subjects?.value
      tags.push "✓ Schlagwörter"
    else
      tags.push "✘ Schlagwörter"

    if custom_settings.add_works?.value
      tags.push "✓ Werke"
    else
      tags.push "✘ Werke"

    if custom_settings.exact_types?.value
      tags.push "✓ Exakter Typ: " + custom_settings.exact_types?.value
    else
      tags.push "✘ Exakter Typ"

    tags


CustomDataType.register(CustomDataTypeGND)
