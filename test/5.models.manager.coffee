vows = require "vows"
assert = require "assert"
core = require "../lib/core"
controllers = require "../lib/controllers"
models = require "../lib/models"

class Model1
	constructor: (@i, @s) ->

test = vows.describe "models.Manager"
test.addBatch
	"":
		topic: ->				
			app = new core.Application()
			app.options.models.classes.push Model1
			new models.Manager()
		"when we create the second instance":
			"we get existing db manager, because Manager is singleton": (topic) ->
				assert.equal topic, new models.Manager()
		"when we try to get model functions save, remove, find":
			"we get them and they are functions": (topic) ->
				m = new Model1(5, "lala")
				assert.isFunction m.save
				assert.isFunction Model1.find
				assert.isFunction m.remove

test.export module

