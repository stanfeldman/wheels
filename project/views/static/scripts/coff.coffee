x = 5 + 3

#lalala
class CounterModel
	constructor: (@value=1) ->
	increase: (v) ->
		@value += v
		
#console.log "hello from coffee, #{new CounterModel().value}"

exports = exports ? this
exports.ext = 555
exports.CounterModel = CounterModel
