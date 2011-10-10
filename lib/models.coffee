class Model
	save: (callback) ->
		if Manager.instance
			new Manager().save this, callback
		
	@find: (conditions, callback) ->
		if Manager.instance
			conditions.model = this
			new Manager().find conditions, callback
		
	remove: ->
		if Manager.instance
			new Manager().remove this

class Manager
	@instance: undefined
	
	constructor: (options) ->
		if Manager.instance isnt undefined
			return Manager.instance
		for obj in options.objects
			obj.constructor extends Model
		AdapterClass = options.adapter
		@adapter = new AdapterClass(options)
		# Adapter class must implement save(model), remove(model), @find(conditions)
		Manager.instance = this
	
	save: (model, callback) ->
		@adapter.save model, callback
	
	find: (conditions, callback) ->
		@adapter.find conditions, callback
	
	remove: (model) ->
		@adapter.remove model

exports.Model = Model
exports.Manager = Manager
