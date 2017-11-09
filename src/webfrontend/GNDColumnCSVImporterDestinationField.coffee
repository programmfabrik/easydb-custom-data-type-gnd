class GNDColumnCSVImporterDestinationField extends ObjecttypeCSVImporterDestinationField
	initOpts: ->
		super()
		@mergeOpt "field",
			check: CustomDataTypeGND

	supportsHierarchy: ->
		false

	getFormat: ->
		"json"