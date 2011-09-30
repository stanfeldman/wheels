vows = require "vows"
assert = require "assert"
core = require "../lib/core"

test = vows.describe "core.Eventer"
test.addBatch
	"":
		topic: -> new core.Eventer()
		"when we create the second instance":
			"we get existing eventer, because Eventer is singleton": (topic) ->
				assert.equal topic, new core.Eventer()

test.export module

