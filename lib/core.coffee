http = require 'http'
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
				classes: []
				adapter: adapters.MongodbAdapter
				host: "127.0.0.1"
				port: 27017
				name: "test"
		require("mootools.js").apply(GLOBAL);
		@options = Object.merge @options, options
		Application.instance = this
	
	start: ->
		if @started
			return
		@eventer = new Eventer()
		@router = new controllers.Router()
		@text_viewer = new views.TextViewer()
		@translator = new views.Translator()
		@db_manager = new models.Manager()
		on_request = (req, res) =>
			@router.route req, res
		server = http.createServer on_request
		server.listen @options.application.port, @options.application.address
		@started = true
		console.log "Server started on http://" + @options.application.address + ":" + @options.application.port + "/"

#Existing events: "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
class Eventer
	@instance: undefined
	
	constructor: ->
		if Eventer.instance isnt undefined
			return Eventer.instance
		@app = new Application()
		Eventer.instance = this
		
	emit: (event) ->
		args = Array.prototype.slice.call arguments, 1
		found = false
		for regex, handler of @app.options.events
			re = new RegExp regex, "ig"
			params = re.exec(event)
			if params
				params = params.splice 1, params.length-1
				found = true
				handler params, args
		if not found and not ["not_found", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"].contains event
			@emit "on_before_not_found", args...

exports.Application = Application
exports.Eventer = Eventer
