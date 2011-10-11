http = require 'http'
rpc = require "now"
controllers = require "./controllers"
views = require "./views"
events = require "events"

class Application
	@instance: undefined

	constructor: (options) ->
		if Application.instance isnt undefined
			return Application.instance
		@options =
			application:
				address: "127.0.0.1",
				port: 1337,
				mode: "debug"
			events:
				"not_found": new controllers.Controller()
			views:
				template_path: "./views/templates/",
				static_path: "./views/static/",
				locale_path: "./views/locales/"
		require("mootools.js").apply(GLOBAL);
		@options = Object.merge @options, options
		Application.instance = this
	
	start: ->
		if @started
			return
		@eventer = new Eventer(@options.events)
		@router = new controllers.Router(@options)
		@text_viewer = new views.TextViewer(@options.views)
		@translator = new views.Translator(@options.views)
		on_request = (req, res) =>
			@router.route req, res
		@server = http.createServer on_request
		@server.listen @options.application.port, @options.application.address
		@rpc_channel = rpc.initialize(@server, {"log level" : 0})
		@started = true
		@eventer.emit "application_started", this
		console.log "Application started on http://" + @options.application.address + ":" + @options.application.port + "/"

#Existing events: "application_started", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
class Eventer
	@instance: undefined
	
	constructor: (events) ->
		if Eventer.instance isnt undefined
			return Eventer.instance
		@events = events
		Eventer.instance = this
		
	emit: (event, args...) ->
		found = false
		for regex, handler of @events
			re = new RegExp regex, "ig"
			params = re.exec(event)
			if params
				params = params[1 .. params.length-1]
				found = true
				if args[0].method and event isnt "not_found"
					handler[args[0].method.toLowerCase()] args..., params...
				else 
					handler[regex] args..., params...
		if not found and not ["application_started", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"].contains event
			@emit "not_found", args...

exports.Application = Application
exports.Eventer = Eventer
