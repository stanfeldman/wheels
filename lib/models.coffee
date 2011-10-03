#var adapters = require("./adapters");
core = require "./core"

class Model
	constructor: ->
		manager = new Manager()
	
	save: ->
		@manager.save this
		
	@find: (coditions) ->
		conditions.model = this
		new Manager().find conditions
		
	remove: ->
		@manager.remove this

class Manager
	@instance: undefined
	
	constructor: () ->
		if Manager.instance isnt undefined
			return Manager.instance
		@app = new core.Application()
		for model in @app.options.models.classes
			model extends Model
		#var AdapterClass = this.options.adapter;
		#this.adapter = new AdapterClass(this.options);
		Manager.instance = this
	
	save: (model) ->
		@adapter.save model
	
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

#exports.Model = Model;
exports.Manager = Manager
exports.Adapter = Adapter
