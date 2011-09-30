#var adapters = require("./adapters");
core = require "./core"
###
class Model
	constructor: (options) ->
		manager = new Manager()
	
	save: function(model)
	{
		this.manager.save(this);
	},
	
	remove: function(model)
	{
		this.manager.remove(this);
	}
});
Model.find = function(conditions)
{
	conditions.model = this;
	new Manager().find(conditions);
};
###

class Manager
	@instance: undefined
	
	constructor: () ->
		if Manager.instance isnt undefined
			return Manager.instance
		@app = new core.Application()
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
