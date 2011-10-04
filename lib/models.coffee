#var adapters = require("./adapters");

class Model
	save: (callback) ->
		new Manager().save this, callback
		
	@find: (coditions) ->
		conditions.model = this
		new Manager().find conditions
		
	remove: ->
		new Manager().remove this

class Manager
	@instance: undefined
	
	constructor: (options) ->
		if Manager.instance isnt undefined
			return Manager.instance
		for model in options.classes
			model extends Model
		# Adapter class must implement save(model), remove(model), @find(conditions)
		AdapterClass = options.adapter;
		@adapter = new AdapterClass(options);
		Manager.instance = this
	
	save: (model, callback) ->
		@adapter.save model, callback
	
	find: (conditions) ->
		@adapter.find conditions
	
	remove: (model) ->
		@adapter.remove model

exports.Model = Model
exports.Manager = Manager
