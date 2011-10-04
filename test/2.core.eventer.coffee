vows = require "vows"
assert = require "assert"
core = require "../lib/core"

test = vows.describe "core.Eventer"
test.addBatch
	"":
		topic: -> 
			app = new core.Application()
			ev = new core.Eventer(app.options.events)
			ev.events["/2$"] = -> 2 + 3
			app.options.events["/3$"] = -> 4 + 3
			return ev
		"when we create the second instance":
			"we get existing eventer, because Eventer is singleton": (topic) ->
				assert.equal topic, new core.Eventer()
		"when we add events to events":
			"we get these events and they are function": (topic) ->
				assert.isFunction topic.events["/2$"]
				assert.isFunction topic.events["/3$"]

test.export module

