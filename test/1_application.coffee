vows = require "vows"
assert = require "assert"
core = require "../lib/core"

test = vows.describe "Application class"
test.addBatch
	"":
		topic: -> 
			options =
				events:
					"/$": -> 1 + 1
				views:
					template_path: __dirname + "/../project/views/templates/"
			app = new core.Application(options)
			return app
		"when we create the second instance":
			"we get existing app, because Application is singleton": (topic) ->
				assert.equal topic, new core.Application()
		"when we set options to app":
			"these options merge with default": (topic) ->
				assert.isFunction topic.options.events["/$"]

test.export module

