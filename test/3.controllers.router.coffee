vows = require "vows"
assert = require "assert"
controllers = require "../lib/controllers"
core = require "../lib/core"

test = vows.describe "controllers.Router"
test.addBatch
	"":
		topic: ->
			app = new core.Application()
			new controllers.Router(app.options)
		"when we create the second instance":
			"we get existing router, because Router is singleton": (topic) ->
				assert.equal topic, new controllers.Router()

test.export module

