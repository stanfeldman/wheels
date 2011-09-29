vows = require "vows"
assert = require "assert"
controllers = require "../lib/controllers"

test = vows.describe "Router class"
test.addBatch
	"":
		topic: ->
			new controllers.Router()
		"when we create the second instance":
			"we get existing router, because Router is singleton": (topic) ->
				assert.equal topic, new controllers.Router()

test.export module

