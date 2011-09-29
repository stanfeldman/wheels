vows = require "vows"
assert = require "assert"
controllers = require "../lib/controllers"
views = require "../lib/views"
core = require "../lib/core"

test = vows.describe "Views"
test.addBatch
	"TextViewer class":
		topic: ->
			new views.TextViewer()
		"when we create the second instance":
			"we get existing textviewer, because TextViewer is singleton": (topic) ->
				assert.equal new views.TextViewer(), new views.TextViewer()

test.export module

