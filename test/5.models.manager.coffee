vows = require "vows"
assert = require "assert"
controllers = require "../lib/controllers"
models = require "../lib/models"

test = vows.describe "models.Manager"
test.addBatch
	"":
		topic: ->
			new models.Manager()
		"when we create the second instance":
			"we get existing db manager, because Manager is singleton": (topic) ->
				assert.equal topic, new models.Manager()

test.export module

