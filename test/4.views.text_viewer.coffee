vows = require "vows"
assert = require "assert"
views = require "../lib/views"
core = require "../lib/core"

test = vows.describe "views.TextViewer"
test.addBatch
	"":
		topic: ->
			app = new core.Application()
			return new views.TextViewer(app.options.views)
		"when we create the second instance":
			"we get existing textviewer, because TextViewer is singleton": (topic) ->
				assert.equal new views.TextViewer(), new views.TextViewer()

test.export module

