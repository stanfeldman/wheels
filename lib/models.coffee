#var adapters = require("./adapters");
core = require "./core"

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
	
	constructor: () ->
		if Manager.instance isnt undefined
			return Manager.instance
		@app = new core.Application()
		for model in @app.options.models.classes
			model extends Model
		AdapterClass = @app.options.models.adapter;
		@adapter = new AdapterClass();
		Manager.instance = this
	
	save: (model, callback) ->
		@adapter.save model, callback
	
	find: (conditions) ->
		@adapter.find conditions
	
	remove: (model) ->
		@adapter.remove model

class Adapter
	save: (model) ->
		throw new TypeError "You must override this method"
	
	find: (conditions) ->
		throw new TypeError "You must override this method"
	
	remove: (model) ->
		throw new TypeError "You must override this method"

exports.Model = Model;
exports.Manager = Manager
exports.Adapter = Adapter
