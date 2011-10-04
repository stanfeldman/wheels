vows = require "vows"
assert = require "assert"
core = require "../lib/core"
controllers = require "../lib/controllers"
models = require "../lib/models"

class Model1
	constructor: (@i, @s) ->

test = vows.describe "models.Model"
test.addBatch
	"":
		topic: ->				
			app = new core.Application()
			app.options.models.classes.push Model1
			new models.Manager(app.options.models)
			return new Model1(5, "lala")
		"when we try to get model functions save, remove, find":
			"we get them and they are functions": (topic) ->
				assert.isFunction topic.save
				assert.isFunction Model1.find
				assert.isFunction topic.remove
		"when we try to save model":
			"we get model object with id property": (topic) ->
				topic.save (err, data) ->
					assert.isNumber data.id

test.export module

