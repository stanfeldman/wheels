vows = require "vows"
assert = require "assert"

test = vows.describe "Devision by zero"
test.addBatch
	"when dividing number by zero":
		topic: -> 42/0
		"we get infinity": (topic) ->
			assert.equal topic, Infinity
	"but when zero by zero":
		topic: -> 0/0
		"we get NaN": (topic) ->
			assert.isNaN topic
test.export module

