vows = require "vows"
assert = require "assert"
views = require "../lib/views"

test = vows.describe "views.TextViewer"
test.addBatch
	"":
		topic: ->
			new views.TextViewer()
		"when we create the second instance":
			"we get existing textviewer, because TextViewer is singleton": (topic) ->
				assert.equal new views.TextViewer(), new views.TextViewer()

test.export module

