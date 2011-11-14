http = require 'http'
#socketio = require "socket.io"
controllers = require "./controllers"
views = require "./views"
events = require "events"
connect = require "connect"
path = require "path"
stylus = require 'stylus'
quip = require 'quip'
dispatch = require './dispatch'

class MyController
	get: (req, res) ->
		console.log res
		res.text 'my controller'

class Application
	@instance: undefined

	constructor: (@options) ->
		if Application.instance isnt undefined
			return Application.instance
		###
		@options =
			application:
				address: "127.0.0.1"
				port: 1337
			events:
				"not_found": new controllers.Controller()
			views:
				template_path: "."
				static_path: "./views/static/"
				locale_path: "./views/locales/"
				cookie_secret: "oweirv020fk"
		require("mootools.js").apply(GLOBAL);
		@options = Object.merge @options, options
		###
		Application.instance = this
	
	start: ->
		if @started
			return
		#@eventer = new Eventer(@options.events)
		#@router = new controllers.Router(@options)
		@text_viewer = new views.TextViewer(@options.views)
		@translator = new views.Translator(@options.views)
		#on_request = (req, res, next) =>
		#	@router.route req, res, next
		@server = connect(
			connect.cookieParser(),
			connect.session({ secret: @options.views.cookie_secret }),
			#(req, res, next) =>
			#	@eventer.emit "before_action", req, res
			#	next()
			stylus.middleware({
				src: @options.views.static_path,
				dest: @options.views.static_path,
				compress: true
			}),
			connect.static(@options.views.static_path),
			quip(),
			dispatch(@options.urls)
			#on_request,
			#,
			#(req, res, next) =>
			#	@eventer.emit "after_action", req, res
			#	next()
		)
		console.log @options.urls
		#@server = @middleware
		#@socketio = socketio.listen @server, {"log level" : 0}
		@server.listen @options.application.port, @options.application.address
		@started = true
		#@eventer.emit "application_started", this
		
	stop: ->
		unless @started
			return
		@server.close()

#Existing events: "application_started", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"
###
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
				if args[0].method and not ["not_found", "application_started", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"].contains event
					handler[args[0].method.toLowerCase()] args..., params...
				else 
					handler[regex] args..., params...
		if not found and not ["application_started", "before_action", "after_action", "before_model_save", "after_model_save", "before_model_remove", "after_model_remove"].contains event
			@emit "not_found", args...
###
exports.Application = Application
#exports.Eventer = Eventer
