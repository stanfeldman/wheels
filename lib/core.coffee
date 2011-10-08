http = require 'http'
rpc = require "now"
controllers = require "./controllers"
models = require "./models"
adapters = require "./adapters"
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
				"not_found": controllers.Controller.on_not_found
			views:
				template_path: "./views/templates/",
				static_path: "./views/static/",
				locale_path: "./views/locales/"
			models:
				objects: []
				adapter: adapters.MysqlAdapter
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
		@db_manager = new models.Manager(@options.models)
		on_request = (req, res) =>
			@router.route req, res
		@server = http.createServer on_request
		@server.listen @options.application.port, @options.application.address
		@rpc_channel = rpc.initialize(@server, {"log level" : 0})
		@started = true
		console.log "Application started on http://" + @options.application.address + ":" + @options.application.port + "/"

#Existing events: "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
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
				handler args..., params...
		if not found and not ["before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"].contains event
			@emit "not_found", args...

exports.Application = Application
exports.Eventer = Eventer
