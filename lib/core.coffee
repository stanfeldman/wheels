coffeescript = require "coffee-script"
http = require 'http'
controllers = require "./controllers"
models = require "./models"
views = require "./views"
events = require "events"
url = require "url"
path = require 'path'
paperboy = require 'paperboy'

class Application
	_instance: undefined
	
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
				#adapter: kiss.models.adapters.MongodbAdapter, 
				host: "127.0.0.1",
				port: 27017,
				name: "test"

	constructor: (options) ->
		if _instance isnt undefined
			return _instance
		_instance = this
		console.log "constr app"
		Application.options = coffeescript.helpers.merge Application.options, options
		console.log Application.options.events
		@eventer = new Eventer()
		@text_viewer = new views.TextViewer()
		#@translator = new views.Translator()
		#new models.Manager()
	
	start: ->
		if @started
			return
		on_request = (req, res) =>
			@route req, res
		server = http.createServer on_request
		server.listen Application.options.application.port, Application.options.application.address
		@started = true
		console.log "Server started on http://" + Application.options.application.address + ":" + Application.options.application.port + "/"
		
	route: (req, res) ->
		#find_action: (req, res) =>
		page_url = url.parse req.url
		req.url = page_url
		console.log "loading " + req.url
		@eventer.emit "before_action", req, res
		@eventer.emit page_url.pathname, req, res
		#if @options.application.mode is "debug"
		#	(paperboy.deliver path.normalize @options.views.static_path, req, res).otherwise find_action
		#else find_action()

#Existing events: "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
class Eventer
	_instance: undefined
	
	constructor: ->
		if _instance isnt undefined
			return _instance
		_instance = this
		
	emit: (event) ->
		args = Array.prototype.slice.call arguments, 1
		found = false
		for regex, handler of Application.options.events
			re = new RegExp regex, "ig"
			params = re.exec(event)
			if params
				params = params.splice 1, params.length-1
				found = true
				handler params, args
		if not found and not ["not_found", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"].contains event
			@emit "not_found", args...

exports.Application = Application
exports.Eventer = Eventer
