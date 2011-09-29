vows = require "vows"
assert = require "assert"
views = require "../lib/views"

test = vows.describe "TextViewer class"
test.addBatch
	"":
		topic: ->
			new views.TextViewer()
		"when we create the second instance":
			"we get existing textviewer, because TextViewer is singleton": (topic) ->
				assert.equal new views.TextViewer(), new views.TextViewer()

test.export module

